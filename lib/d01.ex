defmodule Aoc.D01 do
  alias Aoc.Input

  @answers %{part1: 1141, part2: 6634}
  def answers, do: @answers

  @starting_value 50

  defp parse_instruction(<<?R, val::binary>>), do: String.to_integer(val)
  defp parse_instruction(<<?L, val::binary>>), do: String.to_integer(val) * -1

  defp input(src) do
    Input.read(__MODULE__, src)
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_instruction/1)
  end

  def part1(src \\ :input) do
    input(src)
    |> Enum.reduce({@starting_value, 0}, fn
      val, {old, count} ->
        new = rem(old + val, 100)
        {new, count + if(new == 0, do: 1, else: 0)}
    end)
    |> then(&elem(&1, 1))
  end

  def part2(src \\ :input) do
    {_, res} =
      for instruction <- input(src), reduce: {@starting_value, 0} do
        {curr_pos, count} ->
          new_pos = Integer.mod(curr_pos + instruction, 100)
          curr_zero = if new_pos == 0, do: 1, else: 0

          clicks =
            cond do
              instruction <= 0 ->
                instruction
                |> abs()
                |> div(100)
                |> then(fn n -> if new_pos > curr_pos and curr_pos != 0, do: n + 1, else: n end)

              true ->
                instruction
                |> div(100)
                |> then(fn n -> if new_pos < curr_pos and new_pos != 0, do: n + 1, else: n end)
            end

          from_this_step = curr_zero + clicks - if(curr_pos == 0 and new_pos == 0, do: 1, else: 0)

          {new_pos, count + from_this_step}
      end

    res
  end
end
