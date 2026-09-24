page 50207 "E3 Revenue Batch API"
{
    APIGroup = 'apiHIS';
    APIPublisher = 'mindcurve';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'E3 Revenue Batch API';
    DelayedInsert = true;
    EntityName = 'revenueBatch';
    EntitySetName = 'revenueBatches';
    PageType = API;
    SourceTable = "E3 Revenue API Buffer";
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                    Editable = false;
                }

                field(inputJson; Rec."Input JSON")
                {
                    Caption = 'Input JSON';
                }

                field(responseJson; Rec."Response JSON")
                {
                    Caption = 'Response JSON';
                    Editable = false;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        E3RevenueBatchAPI: Codeunit "E3 Revenue Batch API";
    begin
        Rec."Response JSON" :=
            E3RevenueBatchAPI.ProcessRevenueBatch(
                Rec."Input JSON");

        exit(true);
    end;
}