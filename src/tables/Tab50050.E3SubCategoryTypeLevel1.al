table 50050 "E3 Subcategory Type L1"
{
    Caption = 'Subcategory Type Level1';
    DataClassification = CustomerContent;
    DrillDownPageId = "E3 Subcategory Type L1 List";
    LookupPageId = "E3 Subcategory Type L1 List";

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