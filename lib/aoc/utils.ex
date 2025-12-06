defmodule Aoc.Utils do
  def parallel_process(input, process_fn) do
    input
    |> Task.async_stream(process_fn, max_concurrency: System.schedulers_online())
    |> Enum.map(fn {:ok, results} -> results end)
    |> Enum.sum()
  end

  def transpose(arr), do: Enum.zip_with(arr, &Function.identity/1)
end
