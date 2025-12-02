defmodule Aoc2025.D01 do
  @input "lib/day_01/input.txt"
  @start 50

  defp to_int(str), do: elem(Integer.parse(str), 0)

  def parse_instruction(<<?R, val::binary>>), do: to_int(val)
  def parse_instruction(<<?L, val::binary>>), do: to_int(val) * -1

  def input() do
    File.read!(@input)
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_instruction/1)
  end

  def part1 do
    input()
    |> Enum.reduce({@start, 0}, fn
      val, {old, count} ->
        new = rem(old + val, 100)
        {new, count + if(new == 0, do: 1, else: 0)}
    end)
    |> then(&elem(&1, 1))
  end

  def part2 do
    {_, res} =
      for instruction <- input(), reduce: {@start, 0} do
        {curr_pos, count} ->
          new_pos = Integer.mod(curr_pos + instruction, 100)
          curr_zero = if new_pos == 0, do: 1, else: 0

          clicks =
            cond do
              instruction <= 0 ->
                # we either are not moving or we are moving to the left

                # Let's say we were at position 10 and now we're at 5
                # that's perfectly fine, we could've gotten there by moving -5 or -5 - (100*n)
                # since 5 itself can be represtented with the above formula
                # it suffices to count any instances where we move from a larger number to a smaller number

                # If we were at position 10 and now we find ourselves at position 80
                # we know that can only happen by crossing the 0 boundary, so we know we cross at least once

                # If however we start at position 0 and now we're at position 20
                # we didn't actually cross the 0 boundary we just moved away from it
                # so we need to make sure to not add 1 in this situation

                instruction
                |> abs()
                |> div(100)
                |> then(fn n -> if new_pos > curr_pos and curr_pos != 0, do: n + 1, else: n end)

              true ->
                # we are moving to the right

                # following the same logic as before
                instruction
                |> div(100)
                |> then(fn n -> if new_pos < curr_pos and new_pos != 0, do: n + 1, else: n end)
            end

          total_this_step =
            curr_zero + clicks - if(curr_pos == 0 and new_pos == 0, do: 1, else: 0)

          {new_pos, count + total_this_step}
      end

    res
  end
end
