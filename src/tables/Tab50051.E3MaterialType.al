table 50051 "E3 Manufacturer Type"
{
    Caption = 'Manufacturer Type';
    DataClassification = CustomerContent;
    DrillDownPageId = "E3 Manufacturer Type List";
    LookupPageId = "E3 Manufacturer Type List";

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