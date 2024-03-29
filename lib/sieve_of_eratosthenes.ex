defmodule SieveOfEratosthenes do
  @moduledoc """
  Documentation for `SieveOfEratosthenes`.
    Implementation of sieve of eratosthenes algorithm to calculate all the prime numbers 
    until number given used as limit, using tail recursive optimization and async functions
  """

  @doc """
    Calculate all the primes until given `input` used as limit
  """
  def calculate_primes(input) do
    chunk_size = get_chunk_size(input)

    chunked_list = get_chunked_list(input, chunk_size)

    head = Stream.take(chunked_list, 1) 
        |> Enum.to_list 
        |> Enum.at(0)

    primes = recursive_primes(head, [])

    another_primes = get_non_multiples(chunked_list, primes)

    primes ++ another_primes
  end

  @doc """
    Generate a list between two and `input` number
    And chunk that list by the `chunk_size`

  ## Examples

      iex> SieveOfEratosthenes.get_chunked_list(10, 2) |> Enum.to_list
      [[2, 3], [4, 5], [6, 7], [8, 9], [10]]
  """
  def get_chunked_list(input, chunk_size) do
    Stream.unfold(2, fn
      current when current <= input -> {current, current + 1}
      _ -> nil
    end)
    |> Stream.chunk_every(chunk_size)
  end

  @doc """
    Get the size of the chunk using the square root from `input`
    this number are used to limit the prime calculation using the sieve of eratosthenes algorithm

  ## Examples

      iex> SieveOfEratosthenes.get_chunk_size(1_000)
      32
  """
  def get_chunk_size(input) do
    :math.sqrt(input) 
    |> Float.ceil(0) 
    |> trunc
  end

  @doc """
    filter all non-multiple `numbers` of the given `primes`

  ## Examples

      iex> SieveOfEratosthenes.get_non_multiples([2..100], [2,3,5,7,11])
      [13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]
  """
  def get_non_multiples(numbers, primes) do
    for l <- numbers do
      Task.async(fn -> remove_multiples(primes, l |> Enum.to_list) end)
    end
    |> Task.yield_many(100_000)
    |> Enum.map(fn {t, res} -> elem(res, 1) || Task.shutdown(t, :brutal_kill) end)
    |> Enum.concat
  end

  @doc """
    Calculate all primes of list given using the sieve of eratosthenes algorithm

  ## Examples

      iex> SieveOfEratosthenes.recursive_primes([2,3,4,5,6,7,8,9,10], [])
      [2, 3, 5, 7]
  """
  def recursive_primes([head | tail], primes) do
    recursive_primes(Enum.filter(tail, fn x -> rem(x, head) != 0 end), primes ++ [head])
  end

  def recursive_primes([], list_primes), do: list_primes

  @doc """
    remove all the multiples numbers from given number list using list of prime numbers

  ## Examples

      iex> l = 10..100 |> Enum.to_list
      iex> SieveOfEratosthenes.remove_multiples([2,3,5,7,11], l)
      [13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]
  """
  def remove_multiples([head | tail], number_list) do
    remove_multiples(tail, Enum.filter(number_list, fn x -> rem(x, head) != 0 end))
  end

  def remove_multiples([], number_list), do: number_list

end
