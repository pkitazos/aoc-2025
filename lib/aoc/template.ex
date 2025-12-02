defmodule Aoc.Template do
  def module_name(day), do: "D#{String.pad_leading(to_string(day), 2, "0")}"

  def day_module(day) do
    ~s"""
    defmodule Aoc.#{module_name(day)} do
      alias Aoc.Input

      # @answers %{part1: nil, part2: nil}

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
end
