defmodule Aoc.Template do
  def module_name(day), do: "D#{String.pad_leading(to_string(day), 2, "0")}"

  def day_module(day) do
    ~s"""
    defmodule Aoc.#{module_name(day)} do
      alias Aoc.Input

      # @answers %{part1: nil, part2: nil}

      def input(source \\\\ :input) do
        Input.read(__MODULE__, source)
        |> String.trim()

        # TODO: Parse input
      end

      def part1 do
        input()
        # TODO: Implement part 1
      end

      def part2 do
        input()
        # TODO: Implement part 2
      end
    end

    """
  end
end
