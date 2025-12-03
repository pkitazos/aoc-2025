defmodule Mix.Tasks.Aoc.Bench do
  use Mix.Task
  alias Aoc.CLI

  @shortdoc "Bench the solution for a given day"

  @moduledoc """
  Benchmarks the module containing the solution of the requested Advent of Code day(s).

  Usage:
      mix aoc.bench all
      mix aoc.bench 2
      mix aoc.bench 2 --part 1
      mix aoc.bench 1..5
      mix aoc.bench 1,3,5
  """

  def run(args) do
    Mix.Task.run("app.start")

    {opts, remaining, _} = OptionParser.parse(args, strict: [part: :integer])

    case remaining do
      [] ->
        show_usage()

      [day_spec] ->
        day_spec
        |> Aoc.DayParser.parse()
        |> CLI.bench(opts)
    end
  end

  defp show_usage do
    Mix.shell().info("""
    Usage: mix aoc.bench <day_spec> [options]

    Day specifications:
      all          Benchmark all completed days
      <day>        Benchmark a specific day (e.g., 2)
      <from>..<to> Benchmark a range of days (e.g., 1..5)
      <day>,<day>  Benchmark specific days (e.g., 1,3,5)

    Options:
      --part <n>   Only part 1 or 2

    Examples:
      mix aoc.bench all
      mix aoc.bench 2
      mix aoc.bench 2 --part 1
      mix aoc.bench 1..5
      mix aoc.bench 1,3,5
    """)
  end
end
