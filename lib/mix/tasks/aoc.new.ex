defmodule Mix.Tasks.Aoc.New do
  use Mix.Task

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
      [] ->
        Aoc.CLI.new(opts)

      [day] ->
        Aoc.CLI.new(String.to_integer(day), opts)

      _ ->
        # todo: make show_usage function
        Mix.shell().error("Usage: mix aoc.new [day]")
    end
  end
end
