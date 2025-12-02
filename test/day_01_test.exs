defmodule Aoc2025.Day1Test do
  use ExUnit.Case, asunc: true

  test "day 1 parse instruction" do
    assert Aoc2025.D01.parse_instruction("R8") == 8
    assert Aoc2025.D01.parse_instruction("L19") == -19
  end

  test "day 1 turn dial" do
    assert Aoc2025.D01.apply_rotation(5, -10)
           |> then(&elem(&1, 0))
           |> then(&Aoc2025.D01.normalise/1) == 95

    assert Aoc2025.D01.apply_rotation(95, 5)
           |> then(&elem(&1, 0))
           |> then(&Aoc2025.D01.normalise/1) == 0
  end

  test "day 1 part 1 example" do
    assert Aoc2025.D01.part1() == 3
  end

  test "day 1 part 2 example" do
    assert Aoc2025.D01.part2() == 6
  end
end
