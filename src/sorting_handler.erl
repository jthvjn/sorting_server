-module(sorting_handler).
-behaviour(cowboy_handler).

-export([init/2]).

init(Req0, _State) ->
    Method = cowboy_req:method(Req0),
    case Method of
        <<"POST">> ->
            {ok, Body, Req1} = cowboy_req:read_body(Req0),
            io:format("~n[INFO] Raw Request Body: ~s~n", [Body]),

            case catch jsx:decode(Body, [return_maps]) of
                #{<<"tasks">> := Tasks} ->
                    %% Build response
                    Resp = build_response(Tasks),
                    JsonResp = jsx:encode(Resp),

                    io:format("[INFO] Response JSON: ~s~n", [JsonResp]),

                    Req2 = cowboy_req:reply(200,
                        #{<<"content-type">> => <<"application/json">>},
                        JsonResp,
                        Req1),
                    {ok, Req2, undefined};

                Error ->
                    io:format("[ERROR] Failed to parse JSON: ~p~n", [Error]),

                    JsonErr = jsx:encode(#{error => <<"Invalid">>}),
                    Req2 = cowboy_req:reply(400,
                        #{<<"content-type">> => <<"application/json">>},
                        JsonErr,
                        Req1),
                    {ok, Req2, undefined}
            end;

        _ ->
            io:format("[WARN] Method not allowed: ~s~n", [Method]),
            Req1 = cowboy_req:reply(405, Req0),
            {ok, Req1, undefined}
    end.


build_response(Tasks) ->
    %% Topologically sort tasks.
    SortedTaskNames = sorting_util:sort_task_names(Tasks),

    %% Create a #{task_name => task_map} mapping.
    TaskMap = maps:from_list([ {Name, #{<<"name">> => Name, <<"command">> => maps:get(<<"command">>, Task)}} || #{ <<"name">> := Name } = Task <- Tasks ]),
    
    %% Build the API response
    #{ <<"tasks">> => [maps:get(Name, TaskMap) || Name <- SortedTaskNames] }.



