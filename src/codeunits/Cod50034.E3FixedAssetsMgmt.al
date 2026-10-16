codeunit 50034 "E3 Fixed Assets Mgmt."
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        if not E3APISetup.Get() then
            exit;

        if not E3APISetup."Integration Enabled" then
            exit;
    end;

    var
        E3APISetup: Record "E3 HIS Integartion Setup";

    local procedure GetAuthToken(): Text
    var
        HttpClient: HttpClient;
        HttpContent: HttpContent;
        ContentHeaders: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        LoginJson: JsonObject;
        ResponseJson: JsonObject;
        DataJson: JsonObject;
        TokenValue: JsonToken;
        DataToken: JsonToken;
        RequestBody: Text;
        ResponseBody: Text;
        LoginUrl: Text;
        Token: Text;
    begin
        if not E3APISetup.Get() then
            Error('E3 HIS Integration Setup is not configured.');

        E3APISetup.TestField(Username);
        E3APISetup.TestField(Password);
        E3APISetup.TestField(Host);

        LoginUrl := E3APISetup.Host;

        // Prepare login JSON.
        LoginJson.Add('userName', E3APISetup.Username);
        LoginJson.Add('password', E3APISetup.Password);
        LoginJson.WriteTo(RequestBody);

        HttpContent.WriteFrom(RequestBody);
        HttpContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');

        RequestMessage.Method := 'POST';
        RequestMessage.SetRequestUri(LoginUrl);
        RequestMessage.Content := HttpContent;

        if not HttpClient.Send(RequestMessage, ResponseMessage) then
            Error('Unable to connect to the HIS login API.');

        ResponseMessage.Content.ReadAs(ResponseBody);

        if not ResponseMessage.IsSuccessStatusCode() then
            Error(
                'HIS login failed. HTTP Status: %1. Response: %2',
                ResponseMessage.HttpStatusCode(),
                ResponseBody);

        if not ResponseJson.ReadFrom(ResponseBody) then
            Error(
                'Invalid JSON returned by the HIS login API. Response: %1',
                ResponseBody);

        // Read token from root-level properties.
        if ResponseJson.Get('token', TokenValue) then
            Token := TokenValue.AsValue().AsText()
        else
            if ResponseJson.Get('accessToken', TokenValue) then
                Token := TokenValue.AsValue().AsText()
            else
                if ResponseJson.Get('access_token', TokenValue) then
                    Token := TokenValue.AsValue().AsText()
                else
                    // Also support a token inside "data".
                    if ResponseJson.Get('data', DataToken) then
                        if DataToken.IsObject() then begin
                            DataJson := DataToken.AsObject();

                            if DataJson.Get('token', TokenValue) then
                                Token := TokenValue.AsValue().AsText()
                            else
                                if DataJson.Get('accessToken', TokenValue) then
                                    Token := TokenValue.AsValue().AsText()
                                else
                                    if DataJson.Get('access_token', TokenValue) then
                                        Token := TokenValue.AsValue().AsText();
                        end;

        if Token = '' then
            Error(
                'Token was not found in the HIS login response. Response: %1',
                ResponseBody);

        exit(Token);
    end;

    local procedure GetAuthorizationText(): Text
    begin
        exit('Bearer ' + GetAuthToken());
    end;

    procedure SendFixedAssetsDetails(
        var FixedAssetsUpdateLog: Record "Fixed Asset"): Boolean
    var
        HttpWebClient: HttpClient;
        HttpWebContent: HttpContent;
        ContentHeaders: HttpHeaders;
        RequestHeaders: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;

        RootObj: JsonObject;
        ItemObj: JsonObject;

        ResponseRoot: JsonObject;
        ResponseToken: JsonToken;
        CJToken: JsonToken;

        ReqPayload: Text;
        JsonResponse: Text;
        ResponseMsg: Text;
        AuthorizationText: Text;
        ResultText: Text;
        Succeeded: Boolean;
    begin
        if not E3APISetup.Get() then
            exit(false);

        if not E3APISetup."Integration Enabled" then
            exit(false);

        if not E3APISetup."Fixed Assets API Enabled" then
            exit(false);

        // Generate Bearer token.
        AuthorizationText := GetAuthorizationText();

        // =========================
        // REQUEST BODY
        // =========================
        Clear(ItemObj);

        ItemObj.Add('ItemType', 'General items');
        ItemObj.Add('InterfaceId', Format(FixedAssetsUpdateLog."No."));
        ItemObj.Add('ItemName', FixedAssetsUpdateLog.Description);
        ItemObj.Add('ItemCode', Format(FixedAssetsUpdateLog."No."));
        ItemObj.Add('Itemcategory', 'General Items');
        ItemObj.Add('itemsubcategory', 'Capex Items');
        ItemObj.Add('ItemSubClassification', '');
        ItemObj.Add('HSNNo', Format(FixedAssetsUpdateLog."HSN/SAC Code"));
        ItemObj.Add('ManufacturerCode', 'Other');
        ItemObj.Add('MRPType', '0');
        ItemObj.Add('IsAssetItem', '1');
        ItemObj.Add('IsWorkOrderItem', '0');
        ItemObj.Add('IsExpiryItem', '0');
        ItemObj.Add('IsBatchItem', '0');
        ItemObj.Add('BarcodeUnit', 'Nos.');
        ItemObj.Add('ConversionQty', '1');
        ItemObj.Add('Unit', 'Nos.');
        ItemObj.Add('InterfacingLedgerGroup', 'GENERAL ITEMS');
        ItemObj.Add('TaxSlab', '0');
        ItemObj.Add('HoldingStore', Format(FixedAssetsUpdateLog."FA Location Code"));
        ItemObj.Add(
            'PostingDate',
            Format(
                FixedAssetsUpdateLog.SystemCreatedAt,
                0,
                '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z'));
        // Send the fields directly at the root level.
        // This addresses the API validation error for required fields.
        Clear(RootObj);
        RootObj := ItemObj;
        RootObj.WriteTo(ReqPayload);

        if GuiAllowed then
            Message('Request:\%1', ReqPayload);

        // =========================
        // HTTP REQUEST
        // =========================
        HttpWebContent.WriteFrom(ReqPayload);
        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');

        RequestMessage.Method := 'POST';
        RequestMessage.SetRequestUri(E3APISetup."Fixed Assets API");
        RequestMessage.Content := HttpWebContent;

        // Add Bearer token.
        RequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Add('Authorization', AuthorizationText);

        if not HttpWebClient.Send(RequestMessage, ResponseMessage) then begin
            FixedAssetsUpdateLog.IsSent := false;
            FixedAssetsUpdateLog.Response :=
                CopyStr(
                    'Unable to connect to the General Item Master API.',
                    1,
                    MaxStrLen(FixedAssetsUpdateLog.Response));
            FixedAssetsUpdateLog.Modify(true);
            exit(false);
        end;

        ResponseMessage.Content.ReadAs(JsonResponse);

        if GuiAllowed then
            Message('Response:\%1', JsonResponse);

        // =========================
        // HTTP STATUS CHECK
        // =========================
        if not ResponseMessage.IsSuccessStatusCode() then begin
            FixedAssetsUpdateLog.IsSent := false;
            FixedAssetsUpdateLog.Response :=
                CopyStr(
                    JsonResponse,
                    1,
                    MaxStrLen(FixedAssetsUpdateLog.Response));
            FixedAssetsUpdateLog.Modify(true);
            exit(false);
        end;

        // =========================
        // RESPONSE JSON PARSING
        // =========================
        Clear(ResponseRoot);

        if not ResponseRoot.ReadFrom(JsonResponse) then begin
            FixedAssetsUpdateLog.IsSent := false;
            FixedAssetsUpdateLog.Response :=
                CopyStr(
                    JsonResponse,
                    1,
                    MaxStrLen(FixedAssetsUpdateLog.Response));
            FixedAssetsUpdateLog.Modify(true);
            exit(false);
        end;

        Clear(ResponseToken);
        Clear(CJToken);
        Clear(ResponseMsg);
        Clear(ResultText);
        Succeeded := false;

        // Read message.
        if ResponseRoot.Get('message', CJToken) then
            if not CJToken.AsValue().IsNull() then
                ResponseMsg := CJToken.AsValue().AsText();

        // Primary success indicator: succeeded = true.
        if ResponseRoot.Get('succeeded', ResponseToken) then
            if ResponseToken.AsValue().AsBoolean() then
                Succeeded := true;

        // Fallback success indicator: result = Success.
        if not Succeeded then
            if ResponseRoot.Get('result', ResponseToken) then
                if not ResponseToken.AsValue().IsNull() then begin
                    ResultText := ResponseToken.AsValue().AsText();
                    if UpperCase(ResultText) = 'SUCCESS' then
                        Succeeded := true;
                end;

        if Succeeded then begin
            FixedAssetsUpdateLog.IsSent := true;
            FixedAssetsUpdateLog.Response :=
                CopyStr(
                    JsonResponse,
                    1,
                    MaxStrLen(FixedAssetsUpdateLog.Response));
            FixedAssetsUpdateLog.Modify(true);
            exit(true);
        end;

        // API returned failure.
        FixedAssetsUpdateLog.IsSent := false;
        FixedAssetsUpdateLog.Response :=
            CopyStr(
                JsonResponse,
                1,
                MaxStrLen(FixedAssetsUpdateLog.Response));
        FixedAssetsUpdateLog.Modify(true);

        exit(false);
    end;
}