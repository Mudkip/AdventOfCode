ranges =
  File.read!("2.in")
  |> String.split(",")
  |> Enum.flat_map(fn range_str ->
    [start, stop] =
      range_str
      |> String.split("-")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.to_integer/1)

    start..stop
  end)

part_1 =
  Enum.filter(ranges, fn val ->
    str = Integer.to_string(val)
    len = String.length(str)

    case rem(len, 2) == 0 do
      true -> String.slice(str, 0, div(len, 2)) == String.slice(str, div(len, 2), len)
      _ -> false
    end
  end)
  |> Enum.uniq()
  |> Enum.sum()

part_2 =
  Enum.filter(ranges, fn val ->
    Regex.match?(~r/^(\d+)\1+$/, Integer.to_string(val))
  end)
  |> Enum.uniq()
  |> Enum.sum()

IO.puts("Part 1: #{part_1}")
IO.puts("Part 2: #{part_2}")
