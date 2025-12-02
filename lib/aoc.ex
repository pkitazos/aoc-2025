defmodule Aoc do
  @moduledoc """
  Documentation for `Aoc`.
  """

  @doc """
  Run a specific day

  ## Examples

      iex> Aoc.run(:day_01)
      3

  """
  def run(day) do
    case day do
      :D01_1 -> Aoc.D01.part1()
      :D01_2 -> Aoc.D01.part2()
      :D02_1 -> Aoc.D01.part1()
      _ -> 0
    end
  end
end
