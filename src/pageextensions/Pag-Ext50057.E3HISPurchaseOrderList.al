pageextension 50057 "E3 HIS Purchase Order List" extends "Purchase Order List"
{
    layout
    {
        addlast(Control1)
        {
            field("Transaction Type"; Rec."Transaction Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the transaction type of the document.';
            }
        }
        addafter("Amount Including VAT")
        {
            field("Amount Including GST"; Rec."Amount Including GST")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the sum of amounts, including GST, on all the lines in the document. This will include invoice discounts.';
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Rec.CalculateGSTAmount();
    end;

}