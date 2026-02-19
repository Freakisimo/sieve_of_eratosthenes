defmodule SieveOfEratosthenes do
  @moduledoc """
  Documentation for `SieveOfEratosthenes`.
    Implementation of sieve of eratosthenes algorithm to calculate all the prime numbers
    until number given used as limit, using :atomics for O(1) access and concurrent marking.
  """

  @doc """
    Calculate all the primes until given `input` used as limit.
    Uses an :atomics array as a bitmap where index = number.
    Value 0 means prime, value 1 means composite.

  ## Examples

      iex> SieveOfEratosthenes.calculate_primes(10)
      [2, 3, 5, 7]

      iex> SieveOfEratosthenes.calculate_primes(1)
      []
  """
  @spec calculate_primes(pos_integer()) :: [pos_integer()]
  def calculate_primes(input) when is_integer(input) and input >= 2 do
    sieve = :atomics.new(input + 1, signed: false)
    limit = get_sqrt_limit(input)

    # Step 1: Find small primes up to sqrt(input) sequentially
    small_primes = find_small_primes(sieve, 2, limit, [])

    # Step 2: Mark multiples of each small prime concurrently
    small_primes
    |> Enum.map(fn prime ->
      Task.async(fn -> mark_multiples(sieve, prime, prime * prime, input) end)
    end)
    |> Task.await_many(:infinity)

    # Step 3: Collect all primes from the sieve
    collect_primes(sieve, 2, input, [])
  end

  def calculate_primes(input) when is_integer(input) and input < 2, do: []

  @doc """
    Get the square root limit, used to determine up to which number
    we need to find primes for marking multiples.

  ## Examples

      iex> SieveOfEratosthenes.get_sqrt_limit(1_000)
      32
  """
  @spec get_sqrt_limit(pos_integer()) :: pos_integer()
  def get_sqrt_limit(input) do
    :math.sqrt(input)
    |> Float.ceil(0)
    |> trunc()
  end

  @doc """
    Find small primes up to `limit` by sequentially sieving the :atomics array.
    Returns the list of primes found.

  ## Examples

      iex> sieve = :atomics.new(11, signed: false)
      iex> SieveOfEratosthenes.find_small_primes(sieve, 2, 3, [])
      [2, 3]
  """
  @spec find_small_primes(:atomics.atomics_ref(), pos_integer(), pos_integer(), [pos_integer()]) ::
          [pos_integer()]
  def find_small_primes(_sieve, current, limit, acc) when current > limit do
    Enum.reverse(acc)
  end

  def find_small_primes(sieve, current, limit, acc) do
    if :atomics.get(sieve, current) == 0 do
      mark_multiples(sieve, current, current * current, limit)
      find_small_primes(sieve, current + 1, limit, [current | acc])
    else
      find_small_primes(sieve, current + 1, limit, acc)
    end
  end

  @doc """
    Mark all multiples of `prime` starting from `start` up to `limit` as composite (1)
    in the :atomics sieve.

  ## Examples

      iex> sieve = :atomics.new(11, signed: false)
      iex> SieveOfEratosthenes.mark_multiples(sieve, 2, 4, 10)
      :ok
      iex> :atomics.get(sieve, 4)
      1
      iex> :atomics.get(sieve, 6)
      1
      iex> :atomics.get(sieve, 3)
      0
  """
  @spec mark_multiples(:atomics.atomics_ref(), pos_integer(), pos_integer(), pos_integer()) :: :ok
  def mark_multiples(_sieve, _prime, start, limit) when start > limit, do: :ok

  def mark_multiples(sieve, prime, start, limit) do
    :atomics.put(sieve, start, 1)
    mark_multiples(sieve, prime, start + prime, limit)
  end

  @doc """
    Collect all indices marked as prime (value 0) from the sieve.

  ## Examples

      iex> sieve = :atomics.new(11, signed: false)
      iex> :atomics.put(sieve, 4, 1)
      iex> :atomics.put(sieve, 6, 1)
      iex> :atomics.put(sieve, 8, 1)
      iex> :atomics.put(sieve, 9, 1)
      iex> :atomics.put(sieve, 10, 1)
      iex> SieveOfEratosthenes.collect_primes(sieve, 2, 10, [])
      [2, 3, 5, 7]
  """
  @spec collect_primes(:atomics.atomics_ref(), pos_integer(), pos_integer(), [pos_integer()]) ::
          [pos_integer()]
  def collect_primes(_sieve, current, limit, acc) when current > limit do
    Enum.reverse(acc)
  end

  def collect_primes(sieve, current, limit, acc) do
    if :atomics.get(sieve, current) == 0 do
      collect_primes(sieve, current + 1, limit, [current | acc])
    else
      collect_primes(sieve, current + 1, limit, acc)
    end
  end
end
