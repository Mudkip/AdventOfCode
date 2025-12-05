[ranges_str, products_str] =
  "5.in"
  |> File.read!()
  |> String.trim()
  |> String.split("\n\n")

ranges =
  for line <- String.split(ranges_str, "\n") do
    [s, e] = String.split(line, "-")
    {String.to_integer(s), String.to_integer(e)}
  end

products = products_str |> String.split("\n") |> Enum.map(&String.to_integer/1)

part_1 = Enum.count(products, fn p -> Enum.any?(ranges, fn {s, e} -> p in s..e end) end)

{part_2, _} =
  ranges
  |> Enum.sort()
  |> Enum.reduce({0, -1}, fn {s, e}, {count, prev} ->
    if e > prev, do: {count + e - max(s - 1, prev), e}, else: {count, prev}
  end)

IO.puts("Part 1: #{part_1}")
IO.puts("Part 2: #{part_2}")
