page 50209 "E3 Collection HDR API"
{
    APIGroup = 'apiHIS';
    APIPublisher = 'mindcurve';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'e3CollectionHDRAPI';
    DelayedInsert = true;
    EntityName = 'collectionheader';
    EntitySetName = 'collectionheaders';
    PageType = API;
    SourceTable = "E3 Collection Header";
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

                SubPageLink = "Batch No." = field("Batch No.");
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        DuplicateCheck();
        exit(true);
    end;

    local procedure DuplicateCheck()
    var
        CollectionHeader: Record "E3 Collection Header";
    begin
        if Rec."Validation HIS Key" = '' then
            exit;

        CollectionHeader.Reset();
        CollectionHeader.SetRange(
            "Validation HIS Key",
            Rec."Validation HIS Key");

        if not CollectionHeader.IsEmpty() then
            Error(
                'Duplicate Entry. Validation HIS Key %1 already exists.',
                Rec."Validation HIS Key");
    end;
}