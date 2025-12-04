defmodule Aoc.D02 do
  alias Aoc.Input

  @answers %{part1: 40_214_376_723, part2: 50_793_864_718}
  def answer(1), do: @answers.part1
  def answer(2), do: @answers.part2

  def input(src) do
    Input.read(__MODULE__, src)
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&parse_range/1)
  end

  defp parallel_process(input, process_fn) do
    input
    |> Task.async_stream(process_fn, max_concurrency: System.schedulers_online())
    |> Enum.flat_map(fn {:ok, results} -> results end)
    |> Enum.sum()
  end

  defp parse_range(range) do
    [first, last] =
      range
      |> String.split("-", parts: 2)
      |> Enum.map(&String.to_integer/1)

    first..last
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

  def part1(input), do: parallel_process(input, &process_range/1)

  defp is_invalid?(id) do
    len = String.length(id)
    mid = max(0, div(len, 2) - 1)

    Range.new(0, mid)
    |> Enum.map(fn last -> last + 1 end)
    |> Enum.filter(&(rem(len, &1) == 0))
    |> Enum.any?(&can_repeat_substr_to_form?(id, &1, len))
  end

  defp can_repeat_substr_to_form?(id, substr_len, id_len) do
    substr = String.slice(id, 0, substr_len)
    repetitions = div(id_len, substr_len)
    String.duplicate(substr, repetitions) == id
  end

  defp process_range2(range) do
    range
    |> Enum.map(&Integer.to_string/1)
    |> Enum.reject(&(String.length(&1) == 1))
    |> Enum.filter(&is_invalid?/1)
    |> Enum.map(&String.to_integer/1)
  end

  def part2(input), do: parallel_process(input, &process_range2/1)
end
