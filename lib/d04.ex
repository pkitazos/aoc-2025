defmodule Aoc.D04 do
  alias Aoc.Input

  # @answers %{part1: nil, part2: nil}
  # def answers, do: @answers

  def input(src) do
    Input.read(__MODULE__, src)
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  defp neighbour_rows(idx, range), do: Enum.filter([idx - 1, idx, idx + 1], &(&1 in range))
  # defp neighbour_rows(idx, range), do: for(dx <- -1..1, (idx + dx) in range, do: idx + dx)

  defp construct_neighbourhood(row_idx, input, row_count, col_count) do
    range = 0..(row_count - 1)

    rows =
      row_idx
      |> neighbour_rows(range)
      |> Enum.map(&Enum.at(input, &1))

    cond do
      row_idx == 0 -> [List.duplicate(".", col_count) | rows]
      row_idx == row_count - 1 -> rows ++ [List.duplicate(".", col_count)]
      true -> rows
    end
  end

  defp neighbourhood_coords(idx, range) do
    for dx <- -1..1,
        dy <- 0..2,
        {dx, dy} != {0, 1},
        (idx + dx) in range,
        do: {idx + dx, dy}
  end

  defp process_neighbourhood(row, range) do
    row
    |> Enum.at(1)
    |> Enum.with_index()
    |> Enum.map(fn
      {"@", idx} ->
        idx
        |> neighbourhood_coords(range)
        |> Enum.count(fn
          {x, y} ->
            row
            |> Enum.at(y)
            |> Enum.at(x)
            |> then(&(&1 == "@"))
        end)
        |> then(&(&1 < 4))

      {".", _idx} ->
        nil
    end)
  end

  def part1(input) do
    row_count = length(input)
    col_count = length(Enum.at(input, 0))

    out =
      input
      |> Enum.with_index()
      |> Enum.map(&construct_neighbourhood(elem(&1, 1), input, row_count, col_count))
      |> Enum.map(&process_neighbourhood(&1, 0..(col_count - 1)))
      |> Enum.map(&Enum.count(&1, fn x -> x end))
      |> Enum.sum()

    IO.inspect(out)

    :ok
  end

  def part2(input) do
    input
    # TODO: Implement part 2
  end
end
