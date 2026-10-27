page 50215 "E3 Settlement Subpage"
{
    PageType = ListPart;
    SourceTable = "E3 Settlement Line";
    Caption = 'Settlement Lines';
    ApplicationArea = All;
    SourceTableView = sorting("Entry No.");
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the line entry number.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the line number.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the settlement document number.';
                }
                field("Bill No."; Rec."Bill No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bill number.';
                }
                field("Customer Code"; Rec."Customer Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer code.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer name.';
                }
                field("Bill Date"; Rec."Bill Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bill date.';
                }
                field("Patient Name"; Rec."Patient Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the patient name.';
                }
                field("UHID No."; Rec."UHID No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the patient UHID number.';
                }
                field("Bill Amount"; Rec."Bill Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bill amount.';
                }
                field("Payment Received"; Rec."Payment Received")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payment received.';
                }
                field("Disallowed Amount"; Rec."Disallowed Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the disallowed amount.';
                }
                field("Write off Amount"; Rec."Write off Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the write-off amount.';
                }
                field(TDS; Rec.TDS)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the TDS amount.';
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = All;
                    Caption = 'Cheque No.';
                    ToolTip = 'Specifies the cheque number.';
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                    ApplicationArea = All;
                    Caption = 'Cheque Date';
                    ToolTip = 'Specifies the cheque date.';
                }
                field("Encounter No."; Rec."Encounter No.")
                {
                    ApplicationArea = All;
                    Caption = 'Encounter No.';
                    ToolTip = 'Specifies the encounter number.';
                }
            }
        }
    }
}