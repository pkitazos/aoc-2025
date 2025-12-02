defmodule Aoc.DayParser do
  @moduledoc """
  Parses day specifications from command line arguments.
  """

  @doc """
  Parses a day specification string into days to run.

  Returns one of:
  - `:all` - run all days
  - `integer` - single day
  - `Range.t()` - range of days
  - `[integer]` - list of specific days
  """
  def parse("all"), do: :all

  def parse(spec) do
    cond do
      String.contains?(spec, "..") ->
        [from, to] = String.split(spec, "..")
        String.to_integer(from)..String.to_integer(to)

      String.contains?(spec, ",") ->
        spec
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)

      true ->
        String.to_integer(spec)
    end
  end
end
