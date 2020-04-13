page 50101 TodoListToBeSend
{
    PageType = Worksheet;
    SourceTable = Todo;
    CaptionML = ENU = 'List of Todo to be Send';

    // filter only show completed = true
    SourceTableView = order(descending)
        where(completed = const(true));
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(General)
            {

                field("userId"; "userId")
                {
                    ApplicationArea = All;
                }
                field("id"; "id")
                {
                    ApplicationArea = All;
                }
                field("title"; "title")
                {
                    ApplicationArea = All;
                }
                field("completed"; "completed")
                {
                    ApplicationArea = All;

                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RefreshTodo)
            {
                CaptionML = ENU = 'Refetch Todo';
                Promoted = true;
                PromotedCategory = Process;
                Image = RefreshLines;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    Refetch();
                    CurrPage.Update;
                    if FindFirst then;
                end;
            }

            action(PostTodo)
            {
                CaptionML = ENU = 'Post Todo';
                Promoted = true;
                PromotedCategory = Process;
                Image = PostInventoryToGLTest;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    Post();
                end;
            }
        }
    }
}
