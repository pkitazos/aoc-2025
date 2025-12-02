defmodule Aoc2025.D02 do
  @input "lib/day_02/input.txt"

  defp parse_range(range) do
    [first, last] =
      range
      |> String.split("-", parts: 2)
      |> Enum.map(&String.to_integer/1)

    first..last
  end

  def input do
    File.read!(@input)
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&parse_range/1)
  end

  defp repeats_twice?(id) do
    mid = div(String.length(id), 2)
    {lhs, rhs} = String.split_at(id, mid)
    lhs == rhs
  end

  defp process_range(range) do
    range
    |> Enum.map(&Integer.to_string/1)
    |> Enum.filter(fn id -> rem(String.length(id), 2) == 0 end)
    |> Enum.filter(&repeats_twice?/1)
    |> Enum.map(&String.to_integer/1)
  end

  def part1 do
    input()
    |> Enum.flat_map(&process_range/1)
    |> Enum.sum()
  end
end
