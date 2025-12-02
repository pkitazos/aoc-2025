defmodule Aoc2025 do
  @moduledoc """
  Documentation for `Aoc2025`.
  """

  @doc """
  Run a specific day

  ## Examples

      iex> Aoc2025.run(:day_01)
      3

  """
  def run(day) do
    case day do
      :D01_1 -> D01.part1()
      :D01_2 -> D01.part2()
      _ -> 0
    end
  end
end
