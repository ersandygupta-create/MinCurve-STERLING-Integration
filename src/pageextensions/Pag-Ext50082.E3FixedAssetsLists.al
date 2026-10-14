pageextension 50082 "E3 Fixed Assets List" extends "Fixed Asset List"
{
    layout
    {
        addafter(Acquired)
        {
            field(IsSent; Rec.IsSent)
            {
                ApplicationArea = All;
                Caption = 'IsSent';
                ToolTip = 'Specifies whether the record has been sent.';
            }
            field(Response; Rec.Response)
            {
                ApplicationArea = All;
                Caption = 'Response';
                ToolTip = 'Specifies the API response message.';
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(SendFixedAssets)
            {
                ApplicationArea = All;
                Caption = 'Send Fixed Assets';
                ToolTip = 'Send selected fixed assets individually to the HIS API.';
                Image = SendTo;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    FixedAssets: Record "Fixed Asset";
                    FixedAssetsMgmt: Codeunit "E3 Fixed Assets Mgmt.";
                begin
                    CurrPage.SetSelectionFilter(FixedAssets);

                    if FixedAssets.IsEmpty() then
                        Error('Please select at least one fixed asset.');

                    if FixedAssets.Get(Rec."No.") then
                        FixedAssetsMgmt.SendFixedAssetsDetails(FixedAssets)
                end;
            }
        }
    }

    var
        myInt: Integer;
}