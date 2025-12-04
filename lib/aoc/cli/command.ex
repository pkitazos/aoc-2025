defmodule Aoc.CLI.Command do
  alias Aoc.Template

  def dispatch(cmd, :all, opts), do: discover_days() |> Enum.each(&dispatch(cmd, &1, opts))

  def dispatch(cmd, %Range{} = range, opts), do: Enum.each(range, &dispatch(cmd, &1, opts))

  def dispatch(cmd, days, opts) when is_list(days), do: Enum.each(days, &dispatch(cmd, &1, opts))

  def dispatch(cmd, day, opts) when is_integer(day), do: cmd.(day, opts)

  def call_part(module, part, input), do: apply(module, :"part#{part}", [input])

  def with_parts(day, opts, part_fn) do
    case Keyword.get(opts, :part) do
      nil ->
        part_fn.(day, 1, opts)
        part_fn.(day, 2, opts)

      p when p in [1, 2] ->
        part_fn.(day, p, opts)

      _ ->
        Mix.shell().error("Part must be 1 or 2")
    end
  end

  def with_module(day, fun) do
    module = Module.concat(Aoc, Template.module_name(day))

    if Code.ensure_loaded?(module) do
      fun.(module)
    else
      Mix.shell().error("Day #{day} module not found")
      {:error, :not_found}
    end
  end

  defp discover_days do
    # Need to compile project in order to discover existing modules
    Mix.Task.run("compile")

    1..12
    |> Enum.filter(fn day ->
      module = Module.concat(Aoc, Template.module_name(day))
      Code.ensure_loaded?(module)
    end)
  end
end
