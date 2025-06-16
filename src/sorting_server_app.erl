%%%-------------------------------------------------------------------
%% @doc sorting_server public API
%% @end
%%%-------------------------------------------------------------------

-module(sorting_server_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/sort_tasks", sorting_handler, []},
            {"/bash_script", bash_script_handler, []}
        ]}
    ]),

    {ok, _} = cowboy:start_clear(http_listener,
        [{port, 8080}],
        #{env => #{dispatch => Dispatch}}),
    sorting_server_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
