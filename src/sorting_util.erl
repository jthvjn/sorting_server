-module(sorting_util).

-export([sort_task_names/1]).

%% Generates a topological sort  of DAG  created from the tasks & dependecies.
sort_task_names(Tasks) ->

    %% Take task names as vertices
    Vertices = [ Name || #{ <<"name">> := Name } <- Tasks ],

    %% Create edges, task-1 requires executed task-2.
    Edges = lists:flatten([create_edges(TaskName, DependentTaskNames) 
             || #{ <<"name">> := TaskName, <<"requires">> := DependentTaskNames } <- Tasks]),

    Dag = digraph:new(),

    lists:foreach(fun(Vertex) -> digraph:add_vertex(Dag, Vertex) end, Vertices),
    lists:foreach(fun({U, V}) -> digraph:add_edge(Dag, U, V) end, Edges),

    Sorted = digraph_utils:topsort(Dag),
    digraph:delete(Dag),

    %% Return sorted list of task names
    Sorted.

create_edges(TaskName, DependentTaskNames) ->
    [{DependentTaskName, TaskName} || DependentTaskName <- DependentTaskNames].