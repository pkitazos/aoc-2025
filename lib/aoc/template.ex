defmodule Aoc.Template do
  def module_name(day), do: "D#{String.pad_leading(to_string(day), 2, "0")}"

  def day_module(day) do
    ~s"""
    defmodule Aoc.#{module_name(day)} do
      alias Aoc.Input

      # @answers %{part1: nil, part2: nil}
      # def answers, do: @answers

      def input(src) do
        Input.read(__MODULE__, src)
        |> String.trim()

        # TODO: Parse input
      end

      def part1(src \\\\ :input) do
        input(src)
        # TODO: Implement part 1
      end

      def part2(src \\\\ :input) do
        input(src)
        # TODO: Implement part 2
      end
    end

    """
  end

  def day_test(day) do
    ~s"""
    defmodule Aoc.#{module_name(day)}Test do
      use ExUnit.Case, async: true

      test "day #{day} part 1 example" do
        assert Aoc.#{module_name(day)}.part1(:example) == nil # add part 1 example answer
      end

      test "day #{day} part 2 example" do
        assert Aoc.#{module_name(day)}.part2(:example) == nil # add part 2 example answer
      end
    end

    """
  end
end
