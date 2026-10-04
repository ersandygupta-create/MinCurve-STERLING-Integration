page 50211 "E3 HIS Consumption Header"
{

    ApplicationArea = All;
    Caption = 'HIS Consumption Header';
    PageType = Card;
    Editable = true;
    UsageCategory = Documents;
    SourceTableView = Sorting("Entry No.") where("General Entries Created" = filter(false));
    SourceTable = "E3 Consumption Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field';
                    ApplicationArea = All;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field';
                    ApplicationArea = All;
                    visible = false;
                    editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field';
                    ApplicationArea = All;
                    editable = false;
                }
                field("No. of Lines"; Rec."No. of Lines")
                {
                    ToolTip = 'Specifies the value of the No. of Lines field';
                    ApplicationArea = All;
                    editable = false;
                    Caption = 'No. of Lines';
                }
                field("Validation HIS Key"; Rec."Validation HIS Key")
                {
                    ToolTip = 'Specifies the value of the Validation HIS Key field';
                    ApplicationArea = All;
                    editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field';
                    ApplicationArea = All;
                    editable = false;
                }
                field("Batch No."; Rec."Batch No.")
                {
                    ToolTip = 'Specifies the value of the Batch No. field';
                    ApplicationArea = All;
                    editable = false;
                }
            }
            part(HISConsumptionSubform; "E3 HIS Consumption Entries")
            {
                ApplicationArea = Basic, Suite;
                UpdatePropagation = Both;
                SubPageLink = "Batch No." = FIELD("Batch No.");
                Caption = 'Collection Line';
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Create Consumption Entries")
            {
                ApplicationArea = All;
                Image = CreateLedgerBudget;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Create Consumption Entries action.';
                Caption = 'Create Consumption Entries';
                trigger OnAction();
                var
                    HISPharmacyPost: Codeunit "E3 HIS Integration Mgmt.";
                begin
                    HISPharmacyPost.InitGenJnlLineConsumptionEntry();

                end;
            }
            action("Post Consumption Entries")
            {
                ApplicationArea = All;
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Post Consumption Entries action.';
                Caption = 'Post Consumption Entries';
                trigger OnAction();
                var
                    HISPharmacyPost: Codeunit "E3 HIS Integration Mgmt.";
                begin

                    HISPharmacyPost.PostGenJnlLineConsumptionEntries();
                end;
            }
        }
    }

}
