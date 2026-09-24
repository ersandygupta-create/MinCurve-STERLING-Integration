codeunit 50034 "E3 Revenue Batch API"
{
    procedure ProcessRevenueBatch(InputJson: Text): Text
    var
        InputObject: JsonObject;
        JsonToken: JsonToken;
        JsonArray: JsonArray;
        ResponseArray: JsonArray;
        ResponseObject: JsonObject;
        LineObject: JsonObject;
        ResultText: Text;
        i: Integer;
    begin
        Clear(ResponseArray);
        InputObject.ReadFrom(InputJson);
        if not InputObject.Get('data', JsonToken) then
            Error('Data array is required.');

        JsonArray := JsonToken.AsArray();
        for i := 0 to JsonArray.Count() - 1 do begin
            Clear(LineObject);
            Clear(ResponseObject);

            JsonArray.Get(i, JsonToken);
            LineObject := JsonToken.AsObject();
            ProcessSingleLine(LineObject, ResponseObject, i + 1);
            ResponseArray.Add(ResponseObject);
        end;

        Clear(InputObject);
        InputObject.Add('responses', ResponseArray);
        InputObject.WriteTo(ResultText);
        exit(ResultText);
    end;

    local procedure ProcessSingleLine(LineObject: JsonObject; var ResponseObject: JsonObject; LineNo: Integer)
    var
        RevenueStaging: Record "E3 HIS Revenue Staging Table";
        ExistingRevenueStaging: Record "E3 HIS Revenue Staging Table";
        JsonToken: JsonToken;
        ValidationHISKey: Text;
        HISDocumentType: Text;
    begin
        // Get Validation HIS Key
        if LineObject.Get('validationHISKey', JsonToken) then
            ValidationHISKey := JsonToken.AsValue().AsText();

        // Get HIS Document Type
        if LineObject.Get('hisDocumentType', JsonToken) then
            HISDocumentType := JsonToken.AsValue().AsText();

        // Check duplicate
        if ValidationHISKey <> '' then begin
            ExistingRevenueStaging.Reset();
            ExistingRevenueStaging.SetRange("HIS Document Type", HISDocumentType);
            ExistingRevenueStaging.SetRange("Validation HIS Key", ValidationHISKey);

            if ExistingRevenueStaging.FindFirst() then begin
                ResponseObject.Add('id', Format(LineNo));
                ResponseObject.Add('status', 'Duplicate');
                ResponseObject.Add('message', 'Duplicate Entry');
                exit;
            end;
        end;

        // New record
        RevenueStaging.Init();

        if LineObject.Get('documentNo', JsonToken) then
            RevenueStaging."Document No." := JsonToken.AsValue().AsCode();
        if LineObject.Get('hisDocumentType', JsonToken) then
            RevenueStaging."HIS Document Type" := JsonToken.AsValue().AsText();
        if LineObject.Get('validationHISKey', JsonToken) then
            RevenueStaging."Validation HIS Key" := JsonToken.AsValue().AsText();
        if LineObject.Get('documentDate', JsonToken) then
            RevenueStaging."Document Date" := JsonToken.AsValue().AsDate();
        if LineObject.Get('patientName', JsonToken) then
            RevenueStaging."Patient Name" := JsonToken.AsValue().AsText();
        if LineObject.Get('uhid', JsonToken) then
            RevenueStaging.UHID := JsonToken.AsValue().AsText();
        if LineObject.Get('encounterNo', JsonToken) then
            RevenueStaging."Encounter No." := JsonToken.AsValue().AsText();
        if LineObject.Get('lineNo', JsonToken) then
            RevenueStaging."Line No." := JsonToken.AsValue().AsInteger();
        if LineObject.Get('externalDocumentNo', JsonToken) then
            RevenueStaging."External Document No." := JsonToken.AsValue().AsText();
        if LineObject.Get('shortcutDimension1Code', JsonToken) then
            RevenueStaging."Shortcut Dimension 1 Code" := JsonToken.AsValue().AsText();
        if LineObject.Get('amount', JsonToken) then
            RevenueStaging.Amount := JsonToken.AsValue().AsDecimal();
        if LineObject.Get('chequeNo', JsonToken) then
            RevenueStaging."Cheque No." := JsonToken.AsValue().AsText();
        if LineObject.Get('modeOfPayment', JsonToken) then
            RevenueStaging."Mode of Payment" := JsonToken.AsValue().AsText();
        if LineObject.Get('sponsorCode', JsonToken) then
            RevenueStaging."Sponsor Code" := JsonToken.AsValue().AsText();
        if LineObject.Get('sponsorName', JsonToken) then
            RevenueStaging."Sponsor Name" := JsonToken.AsValue().AsText();
        if LineObject.Get('payerName', JsonToken) then
            RevenueStaging."Payer Name" := JsonToken.AsValue().AsText();
        if LineObject.Get('payorCategory', JsonToken) then
            RevenueStaging."Payor Category" := JsonToken.AsValue().AsText();
        if LineObject.Get('hisBillType', JsonToken) then
            RevenueStaging."HIS Bill Type" := JsonToken.AsValue().AsText();
        if LineObject.Get('bankAccountNo', JsonToken) then
            RevenueStaging."E3 Bank Account No." := JsonToken.AsValue().AsText();
        if LineObject.Get('ifscCode', JsonToken) then
            RevenueStaging."E3 IFSC Code" := JsonToken.AsValue().AsText();
        if LineObject.Get('branch', JsonToken) then
            RevenueStaging."E3 Branch" := JsonToken.AsValue().AsText();

        RevenueStaging."Response Status" := 'Success';
        RevenueStaging."Response Message" := 'Data received successfully';

        RevenueStaging.Insert(true);

        ResponseObject.Add('id', Format(LineNo));
        ResponseObject.Add('status', 'Success');
        ResponseObject.Add(
            'message',
            'Data received successfully');
    end;
}