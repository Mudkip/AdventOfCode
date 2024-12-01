{l, r} = File.stream!("1.in")
  |> Enum.map(&String.trim/1)
  |> Enum.map(&String.split(&1, "   "))
  |> Enum.map(fn list ->
      Enum.map(list, &String.to_integer/1)
  end)
  |> Enum.map(&List.to_tuple/1)
  |> Enum.unzip()

r_counts = Enum.frequencies(r)

part1 = Enum.zip(Enum.sort(l), Enum.sort(r))
  |> Enum.map(fn {x, y} -> abs(x - y) end)
  |> Enum.sum()

part2 = l
  |> Enum.map(fn x -> x * Map.get(r_counts, x, 0) end)
  |> Enum.sum()


IO.puts("Part 1: #{part1}")
IO.puts("Part 2: #{part2}")
