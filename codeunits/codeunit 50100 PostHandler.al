codeunit 50100 PostHandler
{
    procedure Refetch();
    var
        Post: Record Post;
        HttpClient: HttpClient;
        ResponseMessage: HttpResponseMessage;
        JsonToken: JsonToken;
        JsonValue: JsonValue;
        JsonObject: JsonObject;
        JsonArray: JsonArray;
        JsonText: text;
        i: Integer;
    begin
        Post.DeleteAll;

        // Simple web service call
        HttpClient.DefaultRequestHeaders.Add('User-Agent', 'Dynamics 365');
        if not HttpClient.Get('https://jsonplaceholder.typicode.com/posts',
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
            InsertPost(JsonToken);
        end else begin
            // array
            for i := 0 to JsonArray.Count - 1 do begin
                JsonArray.Get(i, JsonToken);
                InsertPost(JsonToken);
            end;
        end;
    end;

    local procedure InsertPost(JsonToken: JsonToken);
    var
        JsonObject: JsonObject;
        Post: Record Post;
    begin
        JsonObject := JsonToken.AsObject;

        Post.init;

        Post."userId" := GetJsonToken(JsonObject, 'userId').AsValue.AsInteger;
        Post."id" := GetJsonToken(JsonObject, 'id').AsValue.AsInteger;
        Post."title" := COPYSTR(GetJsonToken(JsonObject, 'title').AsValue.AsText, 1, 250);
        Post."body" := COPYSTR(GetJsonToken(JsonObject, 'body').AsValue.AsText, 1, 250);

        Post.Insert;
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
