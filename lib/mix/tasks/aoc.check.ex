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
    case args do
      [] ->
        show_usage()

      [day_spec] ->
        day_spec
        |> Aoc.DayParser.parse()
        |> CLI.check()
    end
  end

  defp show_usage do
    Mix.shell().info("""
    Usage: mix aoc.check <day_spec>

    Day specifications:
      all          Run all completed days
      <day>        Run a specific day (e.g., 2)
      <from>..<to> Run a range of days (e.g., 1..5)
      <day>,<day>  Run specific days (e.g., 1,3,5)

    Examples:
      mix aoc.run all
      mix aoc.run 2
      mix aoc.run 1..5
      mix aoc.run 1,3,5
    """)
  end
end
