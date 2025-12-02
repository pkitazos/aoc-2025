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
    case args do
      [] -> Aoc.CLI.new()
      [day] -> Aoc.CLI.new(String.to_integer(day))
      _ -> Mix.shell().error("Usage: mix aoc.new [day]")
    end
  end
end
