codeunit 50101 TodoHandler
{
    procedure PostTodo()
    var
        WebClient: HttpClient;
        Todo: Record Todo;
        WebRequest: HttpRequestMessage;
        WebResponse: HttpResponseMessage;
        WebContentHeaders: HttpHeaders;
        WebContent: HttpContent;
        TodoJson: JsonObject;
        TodoArray: JsonArray;
        TodoText: Text;
        PostSuccess: Boolean;

    begin
        // get all record to be posted Todo
        // assume "completed" is record to be posted
        Todo.Reset();
        Todo.SetRange(completed, true);
        if not Todo.FindSet() then
            Error('There are no Todo to be posted.');
        Message('Total Todo to be posted is ' + Format(todo.Count));

        // construct generic http header for POST request
        WebRequest.Method := 'POST';
        WebRequest.SetRequestUri('https://jsonplaceholder.typicode.com/todos');
        WebContent.GetHeaders(WebContentHeaders);
        if WebContentHeaders.Contains('Content-Type') then
            WebContentHeaders.Remove('Content-Type');
        WebContentHeaders.Add('Content-Type', 'application/json');

        // iterate every single record
        repeat
            Clear(TodoJson);
            TodoJson.Add((Todo.FieldCaption(userId)), Todo.userId);
            TodoJson.Add((Todo.FieldCaption(id)), Todo.id);
            TodoJson.Add((Todo.FieldCaption(title)), Todo.title);
            TodoJson.Add((Todo.FieldCaption(completed)), Todo.completed);
            TodoArray.Add(TodoJson);
            TodoArray.WriteTo(TodoText);
            WebContent.WriteFrom(TodoText);
            WebRequest.Content(WebContent);
            PostSuccess := WebClient.Send(WebRequest, WebResponse);

            Message(StrSubstNo('HTTP Status is %1 - Content Body is %2',
                Format(WebResponse.HttpStatusCode), WebResponse.ReasonPhrase));
        until Todo.Next() = 0;
    end;

    procedure Refetch();
    var
        Todo: Record Todo;
        HttpClient: HttpClient;
        ResponseMessage: HttpResponseMessage;
        JsonToken: JsonToken;
        JsonValue: JsonValue;
        JsonObject: JsonObject;
        JsonArray: JsonArray;
        JsonText: text;
        i: Integer;
    begin
        Todo.DeleteAll;

        // Simple web service call
        HttpClient.DefaultRequestHeaders.Add('User-Agent', 'Dynamics 365');
        if not HttpClient.Get('https://jsonplaceholder.typicode.com/todos',
                              ResponseMessage)
        then
            Error('The call to the web service failed.');

        if not ResponseMessage.IsSuccessStatusCode then
            error('The web service returned an error message:\' +
                  'Status code: %1' +
                  'Description: %2',
                  ResponseMessage.HttpStatusCode,
                  ResponseMessage.ReasonPhrase);

        ResponseMessage.Content.ReadAs(JsonText);

        // Process JSON response
        if not JsonArray.ReadFrom(JsonText) then begin
            // probably single object
            JsonToken.ReadFrom(JsonText);
            InsertTodo(JsonToken);
        end else begin
            // array
            for i := 0 to JsonArray.Count - 1 do begin
                JsonArray.Get(i, JsonToken);
                InsertTodo(JsonToken);
            end;
        end;
    end;

    local procedure InsertTodo(JsonToken: JsonToken);
    var
        JsonObject: JsonObject;
        Todo: Record Todo;
    begin
        JsonObject := JsonToken.AsObject;

        Todo.init;

        Todo."userId" := GetJsonToken(JsonObject, 'userId').AsValue.AsInteger;
        Todo."id" := GetJsonToken(JsonObject, 'id').AsValue.AsInteger;
        Todo."title" := COPYSTR(GetJsonToken(JsonObject, 'title').AsValue.AsText, 1, 250);
        Todo."completed" := GetJsonToken(JsonObject, 'completed').AsValue.AsBoolean;

        Todo.Insert;
    end;

    local procedure GetJsonToken(JsonObject: JsonObject; TokenKey: text) JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error('Could not find a token with key %1', TokenKey);
    end;

    local procedure SelectJsonToken(JsonObject: JsonObject; Path: text) JsonToken: JsonToken;
    begin
        if not JsonObject.SelectToken(Path, JsonToken) then
            Error('Could not find a token with path %1', Path);
    end;

}
