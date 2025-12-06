defmodule Aoc.D03 do
  alias Aoc.{Input, Utils}

  @answers %{part1: 17095, part2: 168_794_698_570_517}
  def answer(1), do: @answers.part1
  def answer(2), do: @answers.part2

  defp parse_bank_digits(bank) do
    bank
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  def input(src) do
    Input.read(__MODULE__, src)
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_bank_digits/1)
  end

  defp find_max_two_in_sequence(bank) do
    last_candidate = length(bank) - 2

    {max_val, max_idx} =
      bank
      |> Enum.slice(0..last_candidate)
      |> Enum.with_index()
      |> Enum.max_by(&elem(&1, 0))

    second_max_val =
      bank
      |> Enum.slice((max_idx + 1)..(last_candidate + 1))
      |> Enum.max()

    {max_val, second_max_val}
  end

  defp process_bank(bank) do
    bank
    |> find_max_two_in_sequence()
    |> then(fn {a, b} -> String.to_integer("#{a}#{b}") end)
  end

  # Original part 1 implementation
  def part1_old(input), do: input |> Utils.parallel_process(&process_bank/1)

  defp max_in_range(slice, range) do
    slice
    |> Enum.with_index()
    |> Enum.map(fn {elt, idx} -> {if(idx not in range, do: -1, else: elt), idx} end)
    |> Enum.max_by(&elem(&1, 0))
  end

  defp find_max_n_in_sequence(bank, n) do
    bank_len = length(bank)

    {_, digits} =
      for i <- 1..n, reduce: {-1, []} do
        {start_idx, acc} ->
          first_candidate = start_idx + 1
          last_candidate = bank_len - n + i - 1

          {max_val, max_idx} = max_in_range(bank, first_candidate..last_candidate)
          {max_idx, [max_val | acc]}
      end

    digits
    |> Enum.reverse()
    |> Integer.undigits()
  end

  # Part 1 is just Part 2 with N=2
  def part1(input), do: Utils.parallel_process(input, &find_max_n_in_sequence(&1, 2))

  def part2(input), do: Utils.parallel_process(input, &find_max_n_in_sequence(&1, 12))
end
