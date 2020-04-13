table 50100 Post
{

    fields
    {

        field(1; "userId"; Integer)
        {
            CaptionML = ENU = 'userId';
        }
        field(2; "id"; Integer)
        {
            CaptionML = ENU = 'id';
        }
        field(3; "title"; Text[250])
        {
            CaptionML = ENU = 'title';
        }
        field(4; "body"; Text[250])
        {
            CaptionML = ENU = 'body';
        }

    }

    keys
    {
        key(PK; id)
        {
            Clustered = true;
        }

    }

    procedure Refetch();
    var
        PostHandler: Codeunit PostHandler;
    begin
        PostHandler.Refetch();
    end;

}
