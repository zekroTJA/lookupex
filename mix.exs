defmodule Lookupex.MixProject do
  use Mix.Project

  def project do
    [
      app: :lookupex,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Lookupex.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:cors_plug, "~> 2.0"},
      {:jason, "~> 1.2"},
      {:tesla, "~> 1.4.0"},
      {:dotenvy, "~> 0.1.0"},
      {:redix, ">= 0.0.0"}
    ]
  end
end
