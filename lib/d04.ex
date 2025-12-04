defmodule Aoc.D04 do
  alias Aoc.Input

  @answers %{part1: 1551, part2: 9784}
  def answer(1), do: @answers.part1
  def answer(2), do: @answers.part2

  def input(src) do
    rows =
      Input.read(__MODULE__, src)
      |> String.trim()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    {parse_grid(rows), length(rows), length(hd(rows))}
  end

  defp parse_grid(rows) do
    for {row, r} <- Enum.with_index(rows),
        {cell, c} <- Enum.with_index(row),
        into: %{},
        do: {{r, c}, cell}
  end

  defp neighbour_coords({r, c}) do
    for dr <- -1..1,
        dc <- -1..1,
        {dr, dc} != {0, 0},
        do: {r + dr, c + dc}
  end

  defp find_removable(grid, height, width, already_removed \\ 0) do
    for r <- 0..(height - 1),
        c <- 0..(width - 1),
        Map.get(grid, {r, c}) == "@",
        reduce: {already_removed, []} do
      {count, coords} ->
        neighbour_count =
          {r, c}
          |> neighbour_coords()
          |> Enum.count(&(Map.get(grid, &1) == "@"))

        if neighbour_count < 4,
          do: {count + 1, [{r, c} | coords]},
          else: {count, coords}
    end
  end

  def part1({grid, height, width}), do: grid |> find_removable(height, width) |> elem(0)

  def part2({grid, height, width}), do: loop(grid, height, width, 0)

  defp loop(grid, height, width, total_removed) do
    {new_total, to_remove} = find_removable(grid, height, width, total_removed)

    case to_remove do
      [] -> new_total
      _ -> loop(Map.merge(grid, Map.new(to_remove, &{&1, "."})), height, width, new_total)
    end
  end
end
