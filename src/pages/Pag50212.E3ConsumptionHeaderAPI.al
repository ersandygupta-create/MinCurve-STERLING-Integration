page 50212 "E3 Consumption HDR API"
{
    APIGroup = 'apiHIS';
    APIPublisher = 'mindcurve';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'e3ConsumptionHDRAPI';
    DelayedInsert = true;
    EntityName = 'consumptionheader';
    EntitySetName = 'consumptionheaders';
    PageType = API;
    SourceTable = "E3 Consumption Header";
    ODataKeyFields = "Validation HIS Key";
    Extensible = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
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
            part(ConsumptionLine; "E3 Consumption API")
            {
                Caption = 'Lines';
                EntityName = 'consumption';
                EntitySetName = 'consumptions';
                SubPageLink = "Batch No." = field("Batch No.");
            }
        }
    }
    local procedure DuplicateCheck()
    var
        ConsumptionHeader: Record "E3 Consumption Header";
    begin
        //ConsumptionHeader.SetRange("Document No.", Rec."Document No.");
        ConsumptionHeader.SetRange("Validation HIS Key", Rec."Validation HIS Key");
        //if not ConsumptionHeader.IsEmpty then
        if ConsumptionHeader.Count >= 1 then
            error('Duplicate Entry');
    end;
}
