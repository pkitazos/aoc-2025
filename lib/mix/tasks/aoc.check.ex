defmodule Mix.Tasks.Aoc.Check do
  use Mix.Task
  alias Aoc.CLI

  @shortdoc "Check solution against answers"

  @moduledoc """
  Checks current implementation against any saved answers

  Usage:
      mix aoc.check all
      mix aoc.check 3
      mix aoc.check 1..5
      mix aoc.check 1,3,5
  """

  def run(args) do
    {opts, remaining, _} = OptionParser.parse(args, strict: [part: :integer])

    case remaining do
      [] ->
        show_usage()

      [day_spec] ->
        day_spec
        |> Aoc.DayParser.parse()
        |> CLI.check(opts)
    end
  end

  defp show_usage do
    Mix.shell().info("""
    Usage: mix aoc.check <day_spec> [options]

    Day specifications:
      all          Check all completed days
      <day>        Check a specific day (e.g., 2)
      <from>..<to> Check a range of days (e.g., 1..5)
      <day>,<day>  Check specific days (e.g., 1,3,5)

    Options:
      --part <n>   Check only part 1 or 2

    Examples:
      mix aoc.check all
      mix aoc.check 2
      mix aoc.check 2 --part 1
      mix aoc.check 1..5
      mix aoc.check 1,3,5
    """)
  end
end
