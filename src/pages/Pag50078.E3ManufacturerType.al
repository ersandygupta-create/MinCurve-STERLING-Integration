page 50078 "E3 Manufacturer Type List"
{
    PageType = List;
    SourceTable = "E3 Manufacturer Type";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Manufacturer Type';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the manufacturer code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the manufacturer description.';
                }
            }
        }
    }
}