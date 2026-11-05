page 50077 "E3 Subcategory Type L1 List"
{
    PageType = List;
    SourceTable = "E3 Subcategory Type L1";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Subcategory Type Level1';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the subcategory code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the subcategory description.';
                }
            }
        }
    }
}