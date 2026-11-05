page 50076 "E3 Category Type List"
{
    PageType = List;
    SourceTable = "E3 Category Type";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Category Type';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category description.';
                }
            }
        }
    }
}