defmodule Aoc.CLI do
  alias Aoc.Template

  def new do
    today = Date.utc_today()

    if today.month == 12 and today.day in 1..12 do
      new(today.day)
    else
      Mix.shell().info("No active Advent of Code day today (must be December 1-25).")
    end
  end

  def new(day) when is_integer(day) do
    module_name = Template.module_name(day)
    content = Template.day_module(day)

    File.write!("lib/#{String.downcase(module_name)}.ex", content)

    input_dir = "priv/inputs/#{String.downcase(module_name)}"
    File.mkdir_p!(input_dir)
    File.touch!("#{input_dir}/input.txt")
    File.touch!("#{input_dir}/example.input.txt")

    Mix.shell().info("Created day #{day}!")
  end
end
