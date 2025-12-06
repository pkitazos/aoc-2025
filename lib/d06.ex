defmodule Aoc.D06 do
  alias Aoc.Input

  @answers %{part1: 5_667_835_681_547, part2: nil}
  def answer(1), do: @answers.part1
  def answer(2), do: @answers.part2

  defp parse_string(str) when str in ["*", "+"], do: String.to_atom(str)
  defp parse_string(str), do: String.to_integer(str)

  defp parse_row(row) do
    row
    |> Enum.reverse()
    |> Enum.map(&parse_string/1)
  end

  def input(src) do
    Input.read(__MODULE__, src)
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.zip_with(&Function.identity/1)
    |> Enum.map(&parse_row/1)
  end

  defp op(:*, a, b), do: a * b
  defp op(:+, a, b), do: a + b

  defp process_row([op | vals]), do: Enum.reduce(vals, &op(op, &1, &2))

  defp parallel_process(input, process_fn) do
    input
    |> Task.async_stream(process_fn, max_concurrency: System.schedulers_online())
    |> Enum.map(fn {:ok, results} -> results end)
    |> Enum.sum()
  end

  def part1(input), do: input |> parallel_process(&process_row/1)

  def part2(input) do
    input
    # TODO: Implement part 2
  end
end
