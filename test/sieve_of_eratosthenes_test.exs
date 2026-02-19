defmodule SieveOfEratosthenesTest do
  use ExUnit.Case
  doctest SieveOfEratosthenes

  test "calculate_primes(2) returns [2]" do
    assert SieveOfEratosthenes.calculate_primes(2) == [2]
  end

  test "calculate_primes(3) returns [2, 3]" do
    assert SieveOfEratosthenes.calculate_primes(3) == [2, 3]
  end

  test "calculate_primes(10) returns first 4 primes" do
    assert SieveOfEratosthenes.calculate_primes(10) == [2, 3, 5, 7]
  end

  test "calculate_primes(1) returns empty list" do
    assert SieveOfEratosthenes.calculate_primes(1) == []
  end

  test "calculate_primes(0) returns empty list" do
    assert SieveOfEratosthenes.calculate_primes(0) == []
  end

  test "get primes until 1_000" do
    assert SieveOfEratosthenes.calculate_primes(1_000) |> length == 168
  end

  test "get primes until 1_000_000" do
    assert SieveOfEratosthenes.calculate_primes(1_000_000) |> length == 78_498
  end

  @tag :slow
  test "get primes until 10_000_000" do
    assert SieveOfEratosthenes.calculate_primes(10_000_000) |> length == 664_579
  end

  @tag :slow
  test "get primes until 1_000_000_000" do
    assert SieveOfEratosthenes.calculate_primes(1_000_000_000) |> length == 50_847_534
  end

  @tag :slow
  test "get primes until 2_000_000_000" do
    assert SieveOfEratosthenes.calculate_primes(2_000_000_000) |> length == 98_222_287
  end

end
