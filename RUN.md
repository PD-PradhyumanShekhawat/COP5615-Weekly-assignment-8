# Run Instructions

Run from the project root.

Compile:
```bash
mkdir -p ebin
erlc -o ebin src/bully_election.erl test/test_bully_election.erl
```

Run tests:
```bash
erl -noshell -pa ebin -s test_bully_election run -s init stop
```

Run default simulation:
```bash
erl -noshell -pa ebin -eval 'bully_election:start().' -s init stop
```

Run a custom scenario:
```bash
erl -noshell -pa ebin -eval 'bully_election:run([1,2,3,4,5], [5], 2).' -s init stop
```

The custom scenario arguments are process IDs, failed process IDs, and the election initiator.
