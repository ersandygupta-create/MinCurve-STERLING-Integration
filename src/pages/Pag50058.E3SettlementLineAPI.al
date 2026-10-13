page 50058 "E3 Settlement Line API"
{
    PageType = API;
    Caption = 'E3 Settlement Line API';
    APIPublisher = 'mindcurve';
    APIGroup = 'apiHIS';
    APIVersion = 'v2.0';
    EntityName = 'settlementLine';
    EntitySetName = 'settlementLines';
    SourceTable = "E3 Settlement Line";
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
                }
                field(lineNo; Rec."Line No.")
                {
                }
                field(billNo; Rec."Bill No.")
                {
                }
                field(customerCode; Rec."Customer Code")
                {
                }
                field(customerName; Rec."Customer Name")
                {
                }
                field(billDate; Rec."Bill Date")
                {
                }
                field(patientName; Rec."Patient Name")
                {
                }
                field(uhidNo; Rec."UHID No.")
                {
                }
                field(billAmount; Rec."Bill Amount")
                {
                }
                field(paymentReceived; Rec."Payment Received")
                {
                }
                field(disallowedAmount; Rec."Disallowed Amount")
                {
                }
                field(writeOffAmount; Rec."Write off Amount")
                {
                }
                field(tds; Rec.TDS)
                {
                }
            }
        }
    }
}