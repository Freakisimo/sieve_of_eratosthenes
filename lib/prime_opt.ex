defmodule PrimeOpt do
  @moduledoc """
  Documentation for `PrimeOpt`.
  """

  def main(input) do
    2..input
    |> calculate_primes
  end

  def calculate_primes(serie) do
    recursive_prime(Enum.to_list(serie), [])
  end

  def recursive_prime([head | tail], primes) do
    rem = Enum.filter(tail, fn x -> rem(x, head) != 0 end)
    # IO.puts length(rem)
    recursive_prime(rem, primes ++ [head])
  end

  def recursive_prime([], list_primes), do: list_primes

end
