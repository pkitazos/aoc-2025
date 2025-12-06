defmodule Aoc.D05 do
  alias Aoc.Input

  @answers %{part1: 598, part2: 360_341_832_208_407}
  def answer(1), do: @answers.part1
  def answer(2), do: @answers.part2

  def input(src, _part \\ nil) do
    {range_lines, id_lines} =
      Input.read(__MODULE__, src)
      |> String.trim()
      |> String.split("\n")
      |> Enum.split_while(&(&1 != ""))

    ranges =
      range_lines
      |> Enum.map(fn str ->
        [from, to] = String.split(str, "-", parts: 2)
        String.to_integer(from)..String.to_integer(to)
      end)

    # id_lines will have the empty string as its head, so we drop it
    ids = id_lines |> tl() |> Enum.map(&String.to_integer/1) |> Enum.sort()

    {ranges, ids}
  end

  defp valid?(id, ranges), do: Enum.any?(ranges, &(id in &1))

  def part1({ranges, ids}), do: ids |> Enum.count(&valid?(&1, ranges))

  defp merge_overlapping([], acc), do: acc
  defp merge_overlapping([{from, to} | rest], []), do: merge_overlapping(rest, [{from, to}])

  defp merge_overlapping([{from, to} | rest], [{curr_from, curr_to} | acc]) do
    if from <= curr_to + 1 do
      merge_overlapping(rest, [{curr_from, max(to, curr_to)} | acc])
    else
      merge_overlapping(rest, [{from, to}, {curr_from, curr_to} | acc])
    end
  end

  def part2({ranges, _}) do
    ranges
    |> Enum.group_by(& &1.first, & &1.last)
    |> Enum.map(fn {from, ends} -> {from, Enum.max(ends)} end)
    |> Enum.sort()
    |> merge_overlapping([])
    |> Enum.sum_by(fn {from, to} -> to - from + 1 end)
  end
end
