defmodule Aoc.D04 do
  alias Aoc.Input

  @answers %{part1: 1551, part2: 9784}
  def answers, do: @answers

  def input(src) do
    input =
      Input.read(__MODULE__, src)
      |> String.trim()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    {parse_grid(input), length(input), length(hd(input))}
  end

  defp parse_grid(input) do
    for({row, x} <- Enum.with_index(input), {elt, y} <- Enum.with_index(row), do: {{x, y}, elt})
    |> Enum.into(%{})
  end

  defp neighbour_coords({x, y}) do
    for dx <- -1..1,
        dy <- -1..1,
        {dx, dy} != {0, 0},
        do: {x + dx, y + dy}
  end

  def part1({grid, row_count, col_count}) do
    for x <- 0..(row_count - 1),
        y <- 0..(col_count - 1),
        Map.get(grid, {x, y}) == "@",
        reduce: 0 do
      acc ->
        neighbour_count =
          {x, y}
          |> neighbour_coords()
          |> Enum.count(fn coord -> Map.get(grid, coord) == "@" end)

        if neighbour_count < 4, do: acc + 1, else: acc
    end
  end

  def part2({grid, row_count, col_count}) do
    loop(grid, row_count, col_count, 0)
  end

  def loop(grid, row_count, col_count, total_removed) do
    {new_total, to_remove} =
      for x <- 0..(row_count - 1),
          y <- 0..(col_count - 1),
          Map.get(grid, {x, y}) == "@",
          reduce: {total_removed, []} do
        {count, coords} ->
          neighbour_count =
            {x, y}
            |> neighbour_coords()
            |> Enum.count(fn coord -> Map.get(grid, coord) == "@" end)

          if neighbour_count < 4 do
            {count + 1, [{x, y} | coords]}
          else
            {count, coords}
          end
      end

    case to_remove do
      [] -> new_total
      _ -> loop(Map.merge(grid, Map.new(to_remove, &{&1, "."})), row_count, col_count, new_total)
    end
  end
end
