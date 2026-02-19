# Changelog

## v0.3.0 (2025-02-19)

  * Enhancements
    * Rewrite sieve implementation using :atomics for O(1) access, replacing list-based approach
    * Add concurrent marking of composite numbers using Task.async (lock-free writes)
    * Add input validation with guard clauses and typespecs
    * Add edge case tests (input 0, 1, 2, 3)
    * Enable 100M benchmark (previously commented out)
    * Fix inconsistent GitHub URL in package config

## v0.2.0 (2023-08-17)

  * Enhancements
    * Improve calculation using streams for lazy evaluation, this change improve excecution time for calculate all prime numbers between 2 and 10M in 2.5 seconds to 0.7 seconds

## v0.1.1 (2021-11-22)

  * Enhancements
    * Add benchmarks using Benchee

## v0.1.0 (2021-11-22)
  * Enhancements
    * First public release