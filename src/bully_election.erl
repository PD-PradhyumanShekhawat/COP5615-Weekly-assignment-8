-module(bully_election).
-export([start/0, run/3, elect/3, validate/2]).

start() ->
    run([1, 2, 3, 4, 5], [5], 2).

run(Ids, Failed, Initiator) ->
    case elect(Ids, Failed, Initiator) of
        {error, Reason} ->
            io:format("VALIDATION: FAIL - ~p~n", [Reason]),
            #{validation => fail, reason => Reason};
        {ok, Result} ->
            io:format("Bully leader-election simulation~n"),
            io:format("Processes: ~p~n", [maps:get(ids, Result)]),
            io:format("Failed processes: ~p~n", [maps:get(failed, Result)]),
            io:format("Initiator: ~p~n", [maps:get(initiator, Result)]),
            io:format("Election messages: ~p~n", [maps:get(election_messages, Result)]),
            io:format("Replies: ~p~n", [maps:get(replies, Result)]),
            io:format("Coordinator announcements: ~p~n",
                      [maps:get(coordinator_announcements, Result)]),
            io:format("Elected coordinator: ~p~n", [maps:get(coordinator, Result)]),
            case validate(Result, Failed) of
                ok ->
                    io:format("VALIDATION: PASS - highest live process elected.~n"),
                    Result#{validation => pass};
                {error, Why} ->
                    io:format("VALIDATION: FAIL - ~p~n", [Why]),
                    Result#{validation => fail, reason => Why}
            end
    end.

elect(Ids0, Failed0, Initiator) ->
    Ids = lists:usort(Ids0),
    Failed = lists:usort(Failed0),
    ValidIds = Ids =/= [] andalso
               lists:all(fun(I) -> is_integer(I) andalso I > 0 end, Ids0),
    ValidFailed = lists:all(fun(I) -> lists:member(I, Ids) end, Failed),
    Alive = [I || I <- Ids, not lists:member(I, Failed)],
    case {ValidIds, length(Ids) =:= length(Ids0), ValidFailed,
          lists:member(Initiator, Alive), Alive} of
        {false, _, _, _, _} -> {error, invalid_process_ids};
        {_, false, _, _, _} -> {error, duplicate_process_ids};
        {_, _, false, _, _} -> {error, unknown_failed_process};
        {_, _, _, _, []} -> {error, no_live_processes};
        {_, _, _, false, _} -> {error, initiator_not_alive};
        _ ->
            HigherAlive = [I || I <- Alive, I > Initiator],
            InitialMessages = [{election, Initiator, I} || I <- HigherAlive],
            Replies = [{ok, I, Initiator} || I <- HigherAlive],
            Escalated = lists:append([
                [{election, I, J} || J <- Alive, J > I]
                || I <- HigherAlive
            ]),
            Coordinator = lists:last(Alive),
            Announcements = [{coordinator, Coordinator, I}
                             || I <- Alive, I =/= Coordinator],
            {ok, #{
                ids => Ids, failed => Failed, alive => Alive,
                initiator => Initiator,
                election_messages => InitialMessages ++ Escalated,
                replies => Replies,
                coordinator_announcements => Announcements,
                coordinator => Coordinator
            }}
    end.

validate(Result, Failed) ->
    Alive = maps:get(alive, Result, []),
    Coordinator = maps:get(coordinator, Result, undefined),
    Expected = case Alive of
        [] -> undefined;
        _ -> lists:last(lists:sort(Alive))
    end,
    Checks = [
        {coordinator_is_alive, lists:member(Coordinator, Alive)},
        {coordinator_is_highest_live, Coordinator =:= Expected},
        {coordinator_not_failed, not lists:member(Coordinator, Failed)}
    ],
    case [Name || {Name, false} <- Checks] of
        [] -> ok;
        [Problem | _] -> {error, Problem}
    end.
