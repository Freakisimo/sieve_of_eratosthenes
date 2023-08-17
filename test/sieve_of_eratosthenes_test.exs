defmodule SieveOfEratosthenesTest do
  use ExUnit.Case
  doctest SieveOfEratosthenes

  test "get primes until 1_000" do
    assert SieveOfEratosthenes.calculate_primes(1_000) |> length == 168
  end

  test "get primes until 1_000_000" do
    assert SieveOfEratosthenes.calculate_primes(1_000_000) |> length == 78_498
  end

  test "get primes until 10_000_000" do
    assert SieveOfEratosthenes.calculate_primes(10_000_000) |> length == 664_579
  end

  test "Return chunk list" do
    assert SieveOfEratosthenes.get_chunked_list(10, 3) |> Enum.to_list == [[2,3,4],[5,6,7],[8,9,10]]
  end

end
