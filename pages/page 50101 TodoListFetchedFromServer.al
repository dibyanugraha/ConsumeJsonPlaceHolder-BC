page 50102 TodoListFetchedFromServer
{
    PageType = List;
    SourceTable = Todo;
    CaptionML = ENU = 'List of Todo';
    Editable = false;

    // filter only show completed = false
    SourceTableView = order(descending)
        where(completed = const(false));
    ApplicationArea = All;
    UsageCategory = Lists;

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
                CaptionML = ENU = 'Refresh Todo';
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
        }
    }
}
