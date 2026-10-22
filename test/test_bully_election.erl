-module(test_bully_election).
-export([run/0]).

run() ->
    {ok, R1} = bully_election:elect([1,2,3,4,5], [5], 2),
    4 = maps:get(coordinator, R1),
    ok = bully_election:validate(R1, [5]),

    {ok, R2} = bully_election:elect([1,2,3,4,5], [4,5], 1),
    3 = maps:get(coordinator, R2),
    ok = bully_election:validate(R2, [4,5]),

    {ok, R3} = bully_election:elect([10,20,30], [], 10),
    30 = maps:get(coordinator, R3),
    ok = bully_election:validate(R3, []),

    {ok, R4} = bully_election:elect([2,4,6,8], [2,6], 4),
    8 = maps:get(coordinator, R4),
    ok = bully_election:validate(R4, [2,6]),

    {error, initiator_not_alive} =
        bully_election:elect([1,2,3], [2], 2),
    {error, duplicate_process_ids} =
        bully_election:elect([1,2,2], [], 1),
    {error, no_live_processes} =
        bully_election:elect([1,2], [1,2], 1),

    Invalid = R1#{coordinator => 5},
    {error, coordinator_is_alive} = bully_election:validate(Invalid, [5]),

    io:format("PASS: Bully election scenarios and validation tests.~n"),
    io:format("PASS: failed initiators, duplicate IDs, all-failed, and invalid leader rejected.~n"),
    Default = bully_election:run([1,2,3,4,5], [5], 2),
    pass = maps:get(validation, Default),
    ok.
