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
        FixedAssets: Record "Fixed Asset";

    procedure SendFixedAssetsDetails(var FixedAssetsUpdateLog: Record "Fixed Asset"): Boolean
    var
        HttpWebClient: HttpClient;
        HttpWebContent: HttpContent;
        ContentHeaders: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;

        RootObj: JsonObject;
        ItemArray: JsonArray;
        ItemObj: JsonObject;

        ResponseRoot: JsonObject;
        ResponseArray: JsonArray;
        ResponseToken: JsonToken;
        ChildObj: JsonObject;
        CJToken: JsonToken;

        ReqPayload: Text;
        JsonResponse: Text;
        ResponseMsg: Text;
        J: Integer;
    begin
        E3APISetup.Get();

        if not E3APISetup."Integration Enabled" then
            exit(false);

        if not E3APISetup."Fixed Assets API Enabled" then
            exit(false);

        E3APISetup.TestField("Fixed Assets API");

        // =========================
        // REQUEST BODY (ARRAY FORMAT)
        // =========================
        Clear(ItemObj);

        ItemObj.Add('ItemType', 'Assets');
        ItemObj.Add('InterfaceId', Format(FixedAssetsUpdateLog."No."));
        ItemObj.Add('ItemName', FixedAssetsUpdateLog.Description);
        ItemObj.Add('ItemCode', Format(FixedAssetsUpdateLog."No."));
        ItemObj.Add('Itemcategory', Format(FixedAssetsUpdateLog."FA Class Code"));
        ItemObj.Add('itemsubcategory', Format(FixedAssetsUpdateLog."FA Subclass Code"));
        ItemObj.Add('ItemSubClassification', Format(FixedAssetsUpdateLog."Sub Asset Group Name"));
        ItemObj.Add('HSNNo', Format(FixedAssetsUpdateLog."HSN/SAC Code"));
        ItemObj.Add('ManufacturerCode', Format(FixedAssetsUpdateLog."Manufacturer Code"));

        ItemObj.Add('MRPType', '');
        ItemObj.Add('IsAssetItem', '1');
        ItemObj.Add('IsWorkOrderItem', '0');
        ItemObj.Add('IsExpiryItem', '0');
        ItemObj.Add('IsBatchItem', '0');
        ItemObj.Add('BarcodeUnit', 'NOS');
        ItemObj.Add('ConversionQty', '1');
        ItemObj.Add('Unit', 'NOS');
        ItemObj.Add('InterfacingLedgerGroup', 'NA');
        ItemObj.Add('TaxSlab', '0');
        ItemObj.Add('HoldingStore', Format(FixedAssetsUpdateLog."Location Code"));
        ItemObj.Add('PostingDate', Format(FixedAssetsUpdateLog.SystemCreatedAt, 0,
                '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>Z'));

        ItemArray.Add(ItemObj);

        Clear(RootObj);
        RootObj.Add('d365_FixedAssetsMast', ItemArray);
        RootObj.WriteTo(ReqPayload);

        if GuiAllowed then
            Message('Request:\%1', ReqPayload);

        HttpWebContent.WriteFrom(ReqPayload);

        HttpWebContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');

        RequestMessage.Content := HttpWebContent;
        RequestMessage.SetRequestUri(E3APISetup."Fixed Assets API");
        RequestMessage.Method := 'POST';

        HttpWebClient.Send(RequestMessage, ResponseMessage);

        ResponseMessage.Content.ReadAs(JsonResponse);

        if GuiAllowed then
            Message('Response:\%1', JsonResponse);

        // Save complete response initially
        FixedAssetsUpdateLog.Response :=
            CopyStr(JsonResponse, 1, MaxStrLen(FixedAssetsUpdateLog.Response));

        // =========================
        // RESPONSE PARSING
        // =========================
        if ResponseMessage.IsSuccessStatusCode then begin

            Clear(ResponseRoot);
            ResponseRoot.ReadFrom(JsonResponse);

            // Corrected node name as per API response
            if ResponseRoot.SelectToken('d365_FixedAssetsMastStatus', ResponseToken) then begin

                Clear(ResponseArray);
                ResponseToken.AsArray().WriteTo(JsonResponse);
                ResponseArray.ReadFrom(JsonResponse);

                for J := 0 to ResponseArray.Count - 1 do begin
                    ResponseArray.Get(J, ResponseToken);

                    ChildObj := ResponseToken.AsObject();

                    Clear(ResponseMsg);
                    if ChildObj.SelectToken('errorMsg', CJToken) then
                        ResponseMsg := CJToken.AsValue().AsText();

                    if ResponseMsg = 'Created Successfully' then begin
                        FixedAssetsUpdateLog.IsSent := true;
                        FixedAssetsUpdateLog.Response :=
                            CopyStr(ResponseMsg, 1, MaxStrLen(FixedAssetsUpdateLog.Response));
                        //FixedAssetsUpdateLog."Last Sent" := CurrentDateTime;
                        FixedAssetsUpdateLog.Modify(true);
                        exit(true);
                    end;
                end;
            end;

            FixedAssetsUpdateLog.IsSent := false;
            FixedAssetsUpdateLog.Response :=
                CopyStr(JsonResponse, 1, MaxStrLen(FixedAssetsUpdateLog.Response));
            //FixedAssetsUpdateLog."Last Sent" := CurrentDateTime;
            FixedAssetsUpdateLog.Modify(true);
            exit(false);

        end else begin
            FixedAssetsUpdateLog.IsSent := false;
            FixedAssetsUpdateLog.Response :=
                CopyStr(JsonResponse, 1, MaxStrLen(FixedAssetsUpdateLog.Response));
            //FixedAssetsUpdateLog."Last Sent" := CurrentDateTime;
            FixedAssetsUpdateLog.Modify(true);
            exit(false);
        end;
    end;
}