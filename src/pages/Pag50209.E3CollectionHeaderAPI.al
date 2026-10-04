page 50209 "E3 Collection HDR API"
{
    APIGroup = 'apiHIS';
    APIPublisher = 'mindcurve';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'e3RevenueHDRAPI';
    DelayedInsert = true;
    EntityName = 'collectionheader';
    EntitySetName = 'collectionheaders';
    PageType = API;
    SourceTable = "E3 Collection Header";
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
            part(RevenueLine; "E3 Advances API")
            {
                Caption = 'Lines';
                EntityName = 'advance';
                EntitySetName = 'advances';
                SubPageLink = "Document No." = field("Document No.");
            }
        }
    }
    local procedure DuplicateCheck()
    var
        RevenueHeader: Record "E3 Collection Header";
    begin
        //RevenueHeader.SetRange("Document No.", Rec."Document No.");
        RevenueHeader.SetRange("Validation HIS Key", Rec."Validation HIS Key");
        //if not RevenueHeader.IsEmpty then
        if RevenueHeader.Count >= 1 then
            error('Duplicate Entry');
    end;
}
