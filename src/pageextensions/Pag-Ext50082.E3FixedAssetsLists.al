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
                    SuccessCount: Integer;
                    ErrorCount: Integer;
                begin
                    CurrPage.SetSelectionFilter(FixedAssets);

                    if FixedAssets.IsEmpty() then
                        Error('Please select at least one fixed asset.');

                    if not Confirm(
                        'Do you want to send the selected fixed assets to HIS individually?',
                        false)
                    then
                        exit;

                    if FixedAssets.FindSet() then
                        repeat
                            // Send each Fixed Asset separately, by No.
                            if FixedAssetsMgmt.SendFixedAssetsDetails(FixedAssets) then
                                SuccessCount += 1
                            else
                                ErrorCount += 1;
                        until FixedAssets.Next() = 0;

                    Message(
                        'Fixed Asset API processing completed.\' +
                        'Total Successful: %1\' +
                        'Total Failed: %2',
                        SuccessCount,
                        ErrorCount);
                end;
            }
        }
    }

    var
        myInt: Integer;
}