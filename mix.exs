defmodule sieve_of_eratosthenes.MixProject do
  use Mix.Project

  def project do
    [
      app: :prime_opt,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "sieve_of_eratosthenes",
      source_url: "https://github.com/Dante7/prime_opt"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.26.0"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  def description() do
    "Implementation of sieve of eratosthenes algorithm to calculate all the prime numbers until number given used as limit, using tail recursive optimization and async functions."
  end

  def package() do
    [
      name: "sieve_of_eratosthenes",
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["José Juan García Rojas"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Dante7/prime_opt"}
    ]
  end

end
