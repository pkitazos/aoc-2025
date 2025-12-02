defmodule Aoc.Input do
  def read(module, source \\ :input) do
    filename =
      case source do
        :input -> "input.txt"
        :example -> "example.input.txt"
      end

    day = module |> Module.split() |> List.last()

    File.read!("priv/inputs/#{day}/#{filename}")
  end
end
