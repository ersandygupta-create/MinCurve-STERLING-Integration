table 50049 "E3 Category Type"
{
    Caption = 'Category Type';
    DataClassification = CustomerContent;
    DrillDownPageId = "E3 Category Type List";
    LookupPageId = "E3 Category Type List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}