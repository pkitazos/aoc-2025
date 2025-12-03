defmodule Aoc.D02Test do
  use ExUnit.Case, asunc: true

  test "day 2 part 1 example" do
    assert Aoc.D02.part1() == 1_227_775_554
  end

  test "day 2 part 2 example" do
    assert Aoc.D02.part2() == 4_174_379_265
  end
end
