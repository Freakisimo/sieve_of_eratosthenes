defmodule PrimeOpt do
  @moduledoc """
  Documentation for `PrimeOpt`.
  """

  def main(input) do
    
    chunk_size = :math.sqrt(input) |> Float.ceil(0) |> trunc

    2..input
    |> Enum.to_list
    |> Enum.chunk_every(chunk_size)
    |> calculate_primes
    |> length

  end

  def calculate_primes([head | tail]) do

    primes = recursive_prime(head, [])
    another_primes = 
    for l <- tail do
      Task.async(fn -> remove_multiples(primes, l) end)
    end
    |> Task.yield_many(10_000)
    |> Enum.map(fn {t, res} -> elem(res, 1) || Task.shutdown(t, :brutal_kill) end)
    |> Enum.concat
    primes ++ another_primes

  end

  def recursive_prime([head | tail], primes) do
    recursive_prime(Enum.filter(tail, fn x -> rem(x, head) != 0 end), primes ++ [head])
  end

  def recursive_prime([], list_primes), do: list_primes

  def remove_multiples([head | tail], number_list) do
    remove_multiples(tail, Enum.filter(number_list, fn x -> rem(x, head) != 0 end))
  end

  def remove_multiples([], number_list), do: number_list

end