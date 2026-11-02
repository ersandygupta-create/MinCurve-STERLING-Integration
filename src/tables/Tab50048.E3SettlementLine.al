table 50048 "E3 Settlement Line"
{
    Caption = 'Settlement Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = SystemMetadata;
        }
        field(3; "Document No."; Code[30])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(4; "Bill No."; Code[30])
        {
            Caption = 'Bill No.';
            DataClassification = CustomerContent;
        }
        field(5; "Customer Code"; Code[30])
        {
            Caption = 'Customer Code';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
            trigger OnValidate()
            var
                CustomerRec: Record Customer;
            begin
                if "Customer Code" <> '' then begin
                    if CustomerRec.Get("Customer Code") then
                        "Customer Name" := CustomerRec.Name;
                end else
                    "Customer Name" := '';
            end;
        }
        field(6; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = CustomerContent;
        }
        field(7; "Bill Date"; Date)
        {
            Caption = 'Bill Date';
            DataClassification = CustomerContent;
        }
        field(8; "Patient Name"; Text[100])
        {
            Caption = 'Patient Name';
            DataClassification = CustomerContent;
        }
        field(9; "UHID No."; Code[50])
        {
            Caption = 'UHID No.';
            DataClassification = CustomerContent;
        }
        field(10; "Bill Amount"; Decimal)
        {
            Caption = 'Bill Amount';
            DataClassification = CustomerContent;
        }
        field(11; "Payment Received"; Decimal)
        {
            Caption = 'Payment Received';
            DataClassification = CustomerContent;
        }
        field(12; "Disallowed Amount"; Decimal)
        {
            Caption = 'Disallowed Amount';
            DataClassification = CustomerContent;
        }
        field(13; "Write off Amount"; Decimal)
        {
            Caption = 'Write off Amount';
            DataClassification = CustomerContent;
        }
        field(14; TDS; Decimal)
        {
            Caption = 'TDS';
            DataClassification = CustomerContent;
        }
        field(15; "Cheque No."; Code[30])
        {
            Caption = 'Cheque No.';
            DataClassification = CustomerContent;
        }
        field(16; "Cheque Date"; Date)
        {
            Caption = 'Cheque Date';
            DataClassification = CustomerContent;
        }
        field(17; "Encounter No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Encounter No.';
        }
        field(18; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(19; "Discount Amount"; Decimal)
        {
            Caption = 'Discount Amount';
            DataClassification = CustomerContent;
        }
        field(20; "Payment Mode"; Text[30])
        {
            Caption = 'Payment Mode';
            DataClassification = CustomerContent;
        }
        field(21; "Handling Charges"; Decimal)
        {
            Caption = 'Handling Charges';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    local procedure GetHISIntegrationSettlementHeader()
    begin
        IF
            ("Document No." <> SettlementHeader."Document No.") THEN BEGIN
            SettlementHeader.Reset();
            SettlementHeader.SetRange("Document No.", "Document No.");
            SettlementHeader.FindFirst();
        END;
    end;

    trigger OnInsert()
    BEGIN
        GetHISIntegrationSettlementHeader();
    END;


    var
        SettlementHeader: Record "E3 Settlement Header";
}