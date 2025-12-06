defmodule Aoc.Template do
  def module_name(day), do: "D#{String.pad_leading(to_string(day), 2, "0")}"

  def day_module(day) do
    ~s"""
    defmodule Aoc.#{module_name(day)} do
      alias Aoc.Input

      @answers %{part1: nil, part2: nil}
      def answer(1), do: @answers.part1
      def answer(2), do: @answers.part2

      def input(src, _part \\\\ nil) do
        Input.read(__MODULE__, src)
        |> String.trim()

        # TODO: Parse input
      end

      def part1(input) do
        input
        # TODO: Implement part 1
      end

      def part2(input) do
        input
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
        # todo: add part 1 example answer
        assert Aoc.#{module_name(day)}.part1(:example) == nil
      end

      test "day #{day} part 2 example" do
        # todo: add part 2 example answer
        assert Aoc.#{module_name(day)}.part2(:example) == nil
      end
    end

    """
  end
end
