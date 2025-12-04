defmodule Aoc.D04Test do
  use ExUnit.Case, async: true

  test "day 4 part 1 example" do
    assert Aoc.D04.part1(:example) == 13
  end

  test "day 4 part 2 example" do
    assert Aoc.D04.part2(:example) == 43
  end
end
