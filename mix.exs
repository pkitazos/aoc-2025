defmodule Aoc.MixProject do
  use Mix.Project

  def project do
    [
      app: :aoc_2025,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:req, "~> 0.5.0"},
      {:dotenvy, "~> 0.8.0"},
      {:benchee, "~> 1.3"},
      {:benchee_json, "~> 1.0", only: :dev},
      {:jason, "~> 1.4"},
      {:owl, "~> 0.12"}
    ]
  end
end
