Benchee.run(
  %{
    "One thousand" => fn -> SieveOfEratosthenes.calculate_primes(1_000) end,
    "Ten thousand" => fn -> SieveOfEratosthenes.calculate_primes(10_000) end,
    "One hundred thousand" => fn -> SieveOfEratosthenes.calculate_primes(100_000) end,
    "One million" => fn -> SieveOfEratosthenes.calculate_primes(1_000_000) end,
    "Ten million" => fn -> SieveOfEratosthenes.calculate_primes(10_000_000) end
    # "One hundred million" => fn -> SieveOfEratosthenes.calculate_primes(100_000_000) end
  }, formatters: [
    {
      Benchee.Formatters.HTML, file: "benchmarks/results/index.html"
    }
  ]
)