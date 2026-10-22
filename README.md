# COP5615 Assignment 8 — Bully Leader Election

## Lecture connection
This assignment simulates the Bully leader-election algorithm discussed in the DOSP lecture. Each process has a unique numeric ID. When an election begins, a process contacts higher-ID processes; the highest-ID process that is alive becomes coordinator.

## Features
- Simulates election scenarios with process IDs and failed processes.
- Records election messages, replies, and coordinator announcements.
- Validates that the elected coordinator is alive and has the highest ID among live processes.
- Includes positive and negative tests for different failure scenarios.

This is a protocol simulation using recorded events, not a networked implementation with independently running Erlang processes. It focuses on the core election logic, not network delay, message loss, or timeout behavior.

## Requirements
Erlang/OTP (`erl` and `erlc`).

See `RUN.md` for commands and `REPORT.md` for the short report.
