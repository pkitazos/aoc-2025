defmodule Mix.Tasks.Aoc.New do
  use Mix.Task
  alias Aoc.CLI

  @shortdoc "Scaffold a new day"

  @moduledoc """
  Scaffolds a new Advent of Code day.

  Usage:
      mix aoc.new 3
      mix aoc.new
  """

  def run(args) do
    # Need to start the application to ensure all dependencies are loaded
    Mix.Task.run("app.start")

    {opts, remaining, _} =
      OptionParser.parse(args,
        switches: [fetch: :boolean]
      )

    case remaining do
      [] -> CLI.new(opts)
      [day] -> CLI.new(String.to_integer(day), opts)
      _ -> show_usage()
    end
  end

  defp show_usage do
    Mix.shell().info("""
    Usage: mix aoc.new [day] [options]

    Arguments:
      [day]        Day number (1-12). If omitted, uses today's date.

    Options:
      --fetch, -f  Fetch puzzle input from adventofcode.com
                   Requires AOC_SESSION in .env file

    Examples:
      mix aoc.new              Create scaffold for today's puzzle
      mix aoc.new 3            Create scaffold for day 3
      mix aoc.new 3 --fetch    Create scaffold and fetch input
    """)
  end
end
