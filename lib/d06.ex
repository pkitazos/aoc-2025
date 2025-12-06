defmodule Aoc.D06 do
  alias Aoc.{Input, Utils}

  @answers %{part1: 5_667_835_681_547, part2: 9_434_900_032_651}
  def answer(1), do: @answers.part1
  def answer(2), do: @answers.part2

  defp parse_op("*"), do: :*
  defp parse_op("+"), do: :+

  defp parse_string(str) when str in ["*", "+"], do: parse_op(str)
  defp parse_string(str), do: String.to_integer(str)

  defp parse_row(row) do
    [op | vals] =
      row
      |> Enum.reverse()
      |> Enum.map(&parse_string/1)

    {op, vals}
  end

  def parse_input_for_part1(input) do
    input
    |> Enum.map(&String.split/1)
    |> Utils.transpose()
    |> Enum.map(&parse_row/1)
  end

  defp parse_digits(row) do
    row
    |> Enum.reject(&(&1 == " "))
    |> Enum.map(&String.to_integer/1)
    |> Integer.undigits()
  end

  defp parse_chunk(chunk) do
    [op_row | val_rows] =
      chunk
      |> Utils.transpose()
      |> Enum.reverse()

    vals =
      val_rows
      |> Enum.reverse()
      |> Utils.transpose()
      |> Enum.map(&parse_digits/1)

    op =
      op_row
      |> Enum.find(&(&1 != " "))
      |> parse_op()

    {op, vals}
  end

  def parse_input_for_part2(input) do
    max_pad =
      input
      |> Enum.map(&String.length/1)
      |> Enum.max()

    chunk_fun = fn row, acc ->
      if Enum.all?(row, &(&1 == " ")) do
        {:cont, Enum.reverse(acc), []}
      else
        {:cont, [row | acc]}
      end
    end

    after_fun = fn
      [] -> {:cont, []}
      acc -> {:cont, Enum.reverse(acc), []}
    end

    input
    |> Enum.map(&String.pad_trailing(&1, max_pad, " "))
    |> Enum.map(&String.graphemes/1)
    |> Utils.transpose()
    |> Enum.chunk_while([], chunk_fun, after_fun)
    |> Enum.map(&parse_chunk/1)
  end

  def input(src) do
    Input.read(__MODULE__, src)
    |> String.trim()
    |> String.split("\n", trim: true)
    |> parse_input_for_part2()
  end

  defp op(:*, a, b), do: a * b
  defp op(:+, a, b), do: a + b

  defp process_row({op, vals}), do: Enum.reduce(vals, &op(op, &1, &2))

  def part1(input), do: input |> Utils.parallel_process(&process_row/1)

  def part2(input), do: input |> Utils.parallel_process(&process_row/1)
end
