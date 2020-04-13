table 50101 Todo
{

    fields
    {

        field(1; "userId"; Integer)
        {
            Caption = 'userId';
        }
        field(2; "id"; Integer)
        {
            Caption = 'id';
        }
        field(3; "title"; Text[250])
        {
            Caption = 'title';
        }
        field(4; "completed"; Boolean)
        {
            Caption = 'completed';
            InitValue = true;
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
        Handler: Codeunit TodoHandler;
    begin
        Handler.Refetch();
    end;

    procedure Post();
    var
        Handler: Codeunit TodoHandler;
    begin
        Handler.PostTodo();
    end;
}
