defmodule Aoc.CLI do
  alias Aoc.Template
  alias Aoc.CLI.Command

  def new(opts) do
    today = Date.utc_today()

    if today.month == 12 and today.day in 1..12 do
      new(today.day, opts)
    else
      Mix.shell().info("No active Advent of Code day today (must be December 1-25).")
    end
  end

  def new(day, opts) when is_integer(day) do
    module_name = Template.module_name(day)
    solution_module_content = Template.day_module(day)
    test_module_content = Template.day_test(day)

    File.write!("lib/#{String.downcase(module_name)}.ex", solution_module_content)
    File.write!("test/#{String.downcase(module_name)}_test.exs", test_module_content)

    input_dir = "priv/inputs/#{String.downcase(module_name)}"
    File.mkdir_p!(input_dir)

    File.touch!("#{input_dir}/input.txt")
    File.touch!("#{input_dir}/example.input.txt")

    if Keyword.get(opts, :fetch, false) do
      fetch_and_save_input(day, input_dir)
    end

    Mix.shell().info("Created day #{day}!")
  end

  defp fetch_and_save_input(day, input_dir) do
    Mix.shell().info("Fetching input for day #{day}...")

    case Aoc.Fetch.fetch_input(day) do
      {:ok, input} ->
        File.write!("#{input_dir}/input.txt", input)
        Mix.shell().info("✓ Input fetched successfully")

      {:error, reason} ->
        Mix.shell().error("✗ Failed to fetch input: #{reason}")
    end
  end

  def run(target, opts), do: Command.dispatch(&run_day/2, target, opts)

  defp run_day(day, opts) do
    time? = Keyword.get(opts, :time, false)
    source = if Keyword.get(opts, :example, false), do: :example, else: :input

    Command.with_parts(day, opts, fn day, part, _opts ->
      Command.with_module(day, fn module ->
        input = module.input(source, part)

        {time_us, result} = :timer.tc(fn -> Command.call_part(module, part, input) end)

        if time? do
          IO.puts("Day #{day}, Part #{part}: #{result} (#{format_time(time_us)})")
        else
          IO.puts("Day #{day}, Part #{part}: #{result}")
        end

        {:ok, result}
      end)
    end)
  end

  defp format_time(us) when us < 1_000, do: "#{us}μs"
  defp format_time(us) when us < 1_000_000, do: "#{Float.round(us / 1_000, 2)}ms"
  defp format_time(us), do: "#{Float.round(us / 1_000_000, 2)}s"

  def check(target, opts), do: Command.dispatch(&check_day/2, target, opts)

  defp check_day(day, opts) do
    Command.with_parts(day, opts, fn day, part, _opts ->
      Command.with_module(day, fn module ->
        input = module.input(:input, part)
        result = Command.call_part(module, part, input)
        expected = module.answer(part)

        case expected do
          nil -> IO.puts("Day #{day}, Part #{part}: #{result} (no answer stored)")
          ^result -> IO.puts("Day #{day}, Part #{part}: #{result} ✓")
          _ -> IO.puts("Day #{day}, Part #{part}: #{result} ✗ Expected: #{expected}")
        end
      end)
    end)
  end

  def bench(target, opts), do: Command.dispatch(&bench_day/2, target, opts)

  defp bench_day(day, opts) do
    source = if Keyword.get(opts, :example, false), do: :example, else: :input

    Command.with_parts(day, opts, fn day, part, _opts ->
      Command.with_module(day, fn module ->
        {:ok, suite} =
          Owl.Spinner.run(
            fn ->
              result =
                Benchee.run(
                  %{
                    "Day #{day} Part #{part}" => fn input ->
                      apply(module, :"part#{part}", [input])
                    end
                  },
                  inputs: %{"Day #{day}" => module.input(source, part)},
                  print: [benchmarking: false, configuration: false, fast_warning: false],
                  formatters: []
                )

              {:ok, result}
            end,
            labels: [processing: "Benchmarking Day #{day} Part #{part}..."]
          )

        average_ns =
          suite.scenarios
          |> List.first()
          |> Map.get(:run_time_data)
          |> Map.get(:statistics)
          |> Map.get(:average)

        average_us = average_ns / 1_000

        Mix.shell().info("Day #{day}, Part #{part}: #{format_time(average_us)}")
      end)
    end)
  end
end
