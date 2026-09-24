table 50045 "E3 Revenue API Buffer"
{
    Caption = 'E3 Revenue API Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Input JSON"; Text[2048])
        {
            Caption = 'Input JSON';
        }
        field(3; "Response JSON"; Text[2048])
        {
            Caption = 'Response JSON';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}