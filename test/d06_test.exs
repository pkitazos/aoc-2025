defmodule Aoc.D06Test do
  use ExUnit.Case, async: true

  test "day 6 part 1 example" do
    assert Aoc.D06.part1(:example) == 4_277_556
  end

  test "day 6 part 2 example" do
    assert Aoc.D06.part2(:example) == 3_263_827
  end
end
