defmodule D01 do
  @input "lib/day_01/input.txt"
  @start 0

  defp to_int(str), do: elem(Integer.parse(str), 0)

  defp parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn
      <<"L", rest::binary>> -> -1 * to_int(rest)
      <<"R", rest::binary>> -> to_int(rest)
    end)
  end

  defp input, do: File.read!(@input) |> parse_input()

  def part1 do
    input()
    |> Enum.reduce({@start, 0}, fn
      val, {old, count} ->
        new = rem(old + val, 100)
        {new, count + if(new == 0, do: 1, else: 0)}
    end)
    |> then(&elem(&1, 1))
  end

  defp polarity(n) when n == 0, do: :zero
  defp polarity(n), do: if(abs(n) == n, do: :pos, else: :neg)

  def rotation_segments(n), do: {abs(div(n, 100)), rem(n, 100)}

  def apply_rotation(curr, incr) do
    res = curr + incr
    norm_res = rem(res, 100)

    clicks =
      case {polarity(curr), polarity(norm_res)} do
        {pol, :zero} when pol != :zero ->
          IO.puts("\t\twent from zero: #{curr} to zero: #{norm_res}")
          1

        {:pos, :neg} ->
          IO.puts("\t\twent from pos: #{curr} to neg: #{norm_res}")
          1

        {:neg, :pos} ->
          IO.puts("\t\twent from neg: #{curr} to pos: #{norm_res}")
          1

        {:neg, :neg} when res < -100 ->
          IO.puts("\t\twent from neg: #{curr} to neg: #{norm_res}")
          1

        {:pos, :pos} when res > 100 ->
          IO.puts("\t\twent from pos: #{curr} to pos: #{norm_res}")
          1

        _ ->
          IO.puts(
            "\t\twent from #{polarity(curr)}: #{curr} to #{polarity(norm_res)}: #{norm_res}"
          )

          0
      end

    {rem(norm_res, 100), clicks}
  end

  def part2 do
    # for incr <- [-276], reduce: {-64, 0} do
    for incr <- input(), reduce: {@start, 0} do
      {curr_pos, curr_count} ->
        {full, rem_incr} = rotation_segments(incr)
        IO.puts("full rotations: #{full}")

        {new_pos, num_clicks} = apply_rotation(curr_pos, rem_incr)
        IO.puts("clicked #{num_clicks} times going from #{curr_pos} to #{new_pos}")

        new_count = curr_count + full + num_clicks

        IO.puts("#{curr_pos}\t->\t#{new_pos}\tvia\t#{incr}\t\t\t//\t#{new_count}")

        {new_pos, new_count}
    end
  end
end
