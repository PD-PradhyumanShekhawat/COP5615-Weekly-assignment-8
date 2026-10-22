# Assignment Report: Bully Leader Election

The lecture introduced leader election as a way to retain the convenience of a coordinator without requiring a permanently separate coordinator that becomes a single point of failure. When a coordinator fails, the remaining processes can elect a replacement.

This assignment simulates the Bully algorithm. Each process has a unique numeric ID, and the highest-ID process that remains alive should become coordinator. An initiating process sends election messages to higher-ID processes. A higher-ID live process can respond and continue the election.

The program records election messages, replies, and coordinator announcements. Its validator checks that the elected coordinator is alive, has the highest ID among live processes, and is not listed as failed. Automated tests cover multiple failure scenarios, different initiators, duplicate IDs, a failed initiator, and the case where all processes have failed.

The simulation is deterministic for each scenario, which makes its expected result straightforward to test. It abstracts away network delays, message loss, independently executing processes, and timeout handling. The focus is the core election logic described in the lecture.
