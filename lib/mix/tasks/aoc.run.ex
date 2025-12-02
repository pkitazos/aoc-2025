defmodule Mix.Tasks.Aoc.Run do
  use Mix.Task
  alias Aoc.CLI

  @shortdoc "Run the solution for a given day"

  @moduledoc """
  Runs the module containing the solution of the requested Advent of Code day(s).

  Usage:
      mix aoc.run all
      mix aoc.run 2
      mix aoc.run 2 --part 1
      mix aoc.run 2 --part 1 --time
      mix aoc.run 2 --time
      mix aoc.run 1..5
      mix aoc.run 1,3,5
  """

  def run(args) do
    {opts, remaining, _} =
      OptionParser.parse(args, strict: [part: :integer, time: :boolean, example: :boolean])

    case remaining do
      [] ->
        show_usage()

      ["all"] ->
        CLI.run(:all, opts)

      [day_spec] ->
        parse_day_spec(day_spec, opts)
    end
  end

  defp parse_day_spec(spec, opts) do
    cond do
      String.contains?(spec, "..") ->
        [from, to] = String.split(spec, "..")
        CLI.run(String.to_integer(from)..String.to_integer(to), opts)

      String.contains?(spec, ",") ->
        days = spec |> String.split(",") |> Enum.map(&String.to_integer/1)
        CLI.run(days, opts)

      true ->
        CLI.run(String.to_integer(spec), opts)
    end
  end

  defp show_usage do
    Mix.shell().info("""
    Usage: mix aoc.run <day_spec> [options]

    Day specifications:
      all          Run all completed days
      <day>        Run a specific day (e.g., 2)
      <from>..<to> Run a range of days (e.g., 1..5)
      <day>,<day>  Run specific days (e.g., 1,3,5)

    Options:
      --part <n>   Run only part 1 or 2
      --time       Show execution time
      --example    Use example.input.txt instead of input.txt

    Examples:
      mix aoc.run 2
      mix aoc.run 2 --part 1
      mix aoc.run 2 --part 1 --time
      mix aoc.run 2 --time --example
      mix aoc.run all
      mix aoc.run 1..5
      mix aoc.run 1,3,5 --time
    """)
  end
end
