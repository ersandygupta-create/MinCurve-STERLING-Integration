page 50208 "E3 HIS Collection Header List"
{

    ApplicationArea = All;
    Caption = 'HIS Collection Header List';
    PageType = List;
    UsageCategory = Lists;
    Editable = false;
    SourceTableView = Sorting("Entry No.") where("General Entries Created" = filter(false));
    SourceTable = "E3 Collection Header";
    CardPageId = "E3 HIS Collection Header";

    layout
    {
        area(content)
        {
            repeater(General)
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
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field';
                    ApplicationArea = All;
                }
                field("No. of Lines"; Rec."No. of Lines")
                {
                    ToolTip = 'Specifies the value of the No. of Lines field';
                    ApplicationArea = All;
                    Caption = 'No. of Lines';
                }
                field("Validation HIS Key"; Rec."Validation HIS Key")
                {
                    ToolTip = 'Specifies the value of the Validation HIS Key field';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field';
                    ApplicationArea = All;
                }
                field("Batch No."; Rec."Batch No.")
                {
                    ToolTip = 'Specifies the value of the Batch No. field';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Create Revenue Entries")
            {
                ApplicationArea = All;
                Image = CreateLedgerBudget;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Create Collection Entries action.';
                Caption = 'Create Collection Entries';
                trigger OnAction();
                var
                    HISIntegration: Codeunit "E3 HIS Integration Mgmt.";
                begin
                    HISIntegration.InitGenJnlLineRevenueStaging();

                end;
            }
            action("Post Revenue Entries")
            {
                ApplicationArea = All;
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Post Collection Entries action.';
                Caption = 'Post Collection Entries';
                trigger OnAction();
                var
                    HISIntegration: Codeunit "E3 HIS Integration Mgmt.";
                begin

                    HISIntegration.PostGenJnlLineEntries();
                end;
            }
        }
    }

}
