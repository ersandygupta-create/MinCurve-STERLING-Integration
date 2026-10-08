page 50215 "E3 Settlement HDR API"
{
    APIGroup = 'apiHIS';
    APIPublisher = 'mindcurve';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'e3SettlementHDRAPI';
    DelayedInsert = true;
    EntityName = 'settlementheader';
    EntitySetName = 'settlementheaders';
    PageType = API;
    SourceTable = "E3 Settlement Header";
    ODataKeyFields = SystemId;
    Extensible = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                    Editable = false;
                }
                field(validationHISKey; Rec."Validation HIS Key")
                {
                    Caption = 'Validation HIS Key';

                    trigger OnValidate()
                    begin
                        DuplicateCheck();
                    end;
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(noOfLines; Rec."No. of Lines")
                {
                    Caption = 'No. of Lines';
                }
                field(shortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Shortcut Dimension 1 Code';
                }
                field(batchNo; Rec."Batch No.")
                {
                    Caption = 'Batch No.';
                }

            }
            part(SettlementLine; "E3 Settlement API")
            {
                Caption = 'Lines';
                EntityName = 'settlement';
                EntitySetName = 'settlements';
                SubPageLink = "Batch No." = field("Batch No.");
            }
        }
    }
    local procedure DuplicateCheck()
    var
        SettlementHeader: Record "E3 Settlement Header";
    begin
        //SettlementHeader.SetRange("Document No.", Rec."Document No.");
        SettlementHeader.SetRange("Validation HIS Key", Rec."Validation HIS Key");
        //if not SettlementHeader.IsEmpty then
        if SettlementHeader.Count >= 1 then
            error('Duplicate Entry');
    end;
}
