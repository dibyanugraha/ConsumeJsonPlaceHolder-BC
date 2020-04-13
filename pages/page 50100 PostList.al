page 50100 PostList
{
    PageType = List;
    SourceTable = Post;
    CaptionML = ENU = 'List of Post';
    Editable = false;
    SourceTableView = order(descending);
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
                field("body"; "body")
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
            action(Refetch)
            {
                CaptionML = ENU = 'Refetch';
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
