defmodule BatteryGenie do
  def largest_number(digits, k) do
    select_digits(digits, k)
    |> Integer.undigits()
  end

  def select_digits(digits, k) do
    n = length(digits)
    indexed = Enum.with_index(digits)

    {result, _} =
      Enum.reduce(0..(k - 1), {[], 0}, fn i, {acc, start_idx} ->
        end_idx = n - k + i

        {max_val, max_idx} =
          indexed
          |> Enum.slice(start_idx..end_idx)
          |> Enum.max_by(fn {val, _} -> val end)

        {acc ++ [max_val], max_idx + 1}
      end)

    result
  end
end

{part_1, part_2} =
  File.stream!("3.in")
  |> Enum.reduce({0, 0}, fn line, {p1, p2} ->
    digits = line |> String.trim() |> String.graphemes() |> Enum.map(&String.to_integer/1)
    {p1 + BatteryGenie.largest_number(digits, 2), p2 + BatteryGenie.largest_number(digits, 12)}
  end)

IO.puts("Part 1: #{part_1}")
IO.puts("Part 2: #{part_2}")
