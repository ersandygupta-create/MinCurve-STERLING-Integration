page 50057 "E3 Settlement Header API"
{
    PageType = API;
    Caption = 'E3 Settlement Header API';
    APIPublisher = 'mindcurve';
    APIGroup = 'apiHIS';
    APIVersion = 'v2.0';
    EntityName = 'settlementHeader';
    EntitySetName = 'settlementHeaders';
    SourceTable = "E3 Settlement Header";
    ODataKeyFields = "Entry No.";
    DelayedInsert = true;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(documentNo; Rec."Document No.")
                {
                    trigger OnValidate()
                    begin
                        DuplicateCheck();
                    end;
                }
                field(hisDocumentType; Rec."HIS Document Type")
                {
                }
                field(documentDate; Rec."Document Date")
                {
                }
                field(receivedAmount; Rec."Received Amount")
                {
                }
                field(accountType; Rec."Account Type")
                {
                }
                field(accountNo; Rec."Account No.")
                {
                }
                field(balAccountType; Rec."Bal. Account Type")
                {
                }
                field(balAccountNo; Rec."Bal. Account No")
                {
                }
                field(instrumentNo; Rec."Instrument No.")
                {
                }
                field(instrumentDate; Rec."Instrument Date")
                {
                }
                field(hisValidationKey; Rec."HIS Validation Key")
                {
                }
                field(noOfLines; Rec."No. of Lines")
                {
                }
            }
            part(SettlementLine; "E3 Settlement Line API")
            {
                Caption = 'Lines';
                EntityName = 'settlementLine';
                EntitySetName = 'settlementLines';
                SubPageLink = "Document No." = field("Document No.");
            }
        }
    }
    local procedure DuplicateCheck()
    var
        SettlementHeader: Record "E3 Settlement Header";
    begin
        SettlementHeader.SetRange("Document No.", Rec."Document No.");
        if SettlementHeader.Count >= 1 then
            error('Duplicate Entry');
    end;
}