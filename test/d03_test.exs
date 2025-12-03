defmodule Aoc.D03Test do
  use ExUnit.Case, async: true

  test "day 3 part 1 example" do
    assert Aoc.D03.part1(:example) == 357
  end

  test "day 3 part 2 example" do
    assert Aoc.D03.part2(:example) == 3_121_910_778_619
  end
end
