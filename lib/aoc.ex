defmodule Aoc do
  @moduledoc """
  Advent of Code 2025 solutions.
  """

  @doc """
  Quick helper to run a day from IEx.

  ## Examples

      iex> Aoc.run(1)
      iex> Aoc.run(2, part: 1)
      iex> Aoc.run(3, example: true)
  """
  defdelegate run(day, opts \\ []), to: Aoc.CLI
end
