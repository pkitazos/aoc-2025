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

  defp discover_days do
    Mix.Task.run("compile")

    1..12
    |> Enum.filter(fn day ->
      module = Module.concat(Aoc, Template.module_name(day))
      Code.ensure_loaded?(module)
    end)
  end

  def run(:all, opts), do: discover_days() |> Enum.each(&run(&1, opts))

  def(run(%Range{} = range, opts), do: Enum.each(range, &run(&1, opts)))

  def run(days, opts) when is_list(days), do: Enum.each(days, &run(&1, opts))

  def run(day, opts) when is_integer(day) do
    part = Keyword.get(opts, :part)
    time? = Keyword.get(opts, :time, false)
    source = if Keyword.get(opts, :example, false), do: :example, else: :input

    case part do
      nil ->
        run_part(day, 1, source, time?)
        run_part(day, 2, source, time?)

      p when p in [1, 2] ->
        run_part(day, p, source, time?)

      _ ->
        Mix.shell().error("Part must be 1 or 2")
    end
  end

  defp run_part(day, part, source, time?) do
    module = Module.concat(Aoc, Template.module_name(day))

    if Code.ensure_loaded?(module) do
      function = :"part#{part}"

      if time? do
        {time_us, result} = :timer.tc(fn -> apply(module, function, [source]) end)
        IO.puts("Day #{day}, Part #{part}: #{result} (#{format_time(time_us)})")
        {:ok, result}
      else
        result = apply(module, function, [source])
        IO.puts("Day #{day}, Part #{part}: #{result}")
        {:ok, result}
      end
    else
      err = "Day #{day} module not found"
      Mix.shell().error(err)
      {:error, err}
    end
  end

  defp format_time(us) when us < 1_000, do: "#{us}μs"
  defp format_time(us) when us < 1_000_000, do: "#{Float.round(us / 1_000, 2)}ms"
  defp format_time(us), do: "#{Float.round(us / 1_000_000, 2)}s"

  def check(:all), do: discover_days() |> Enum.each(&check/1)
  def check(%Range{} = range), do: Enum.each(range, &check/1)
  def check(days) when is_list(days), do: Enum.each(days, &check/1)

  def check(day) when is_integer(day) do
    module = Module.concat(Aoc, Template.module_name(day))

    if Code.ensure_loaded?(module) do
      answers = module.answers()

      res1 = apply(module, :part1, [:input])
      res2 = apply(module, :part2, [:input])

      verify(day, 1, res1, answers.part1)
      verify(day, 2, res2, answers.part2)
    else
      Mix.shell().error("Day #{day} not found")
    end
  end

  defp verify(day, part, result, expected) do
    case expected do
      nil ->
        IO.puts("Day #{day}, Part #{part}: #{result} (no answer stored)")

      ^result ->
        IO.puts("Day #{day}, Part #{part}: #{result} ✓")

      _ ->
        IO.puts("Day #{day}, Part #{part}: #{result} ✗ Expected: #{expected}")
    end
  end
end
