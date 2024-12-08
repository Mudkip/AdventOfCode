defmodule Main do
  def solve(input) do
    height = length(input)
    width = length(Enum.at(input, 0))

    for {row, y} <- Enum.with_index(input),
        {symbol, x} <- Enum.with_index(row),
        symbol != ".",
        reduce: %{} do
      acc -> Map.update(acc, symbol, [{x, y}], &[{x, y} | &1])
    end
    |> Enum.flat_map(fn {_symbol, coords} ->
      for a <- coords,
          b <- coords,
          a != b,
          k <- 0..height,
          {ax, ay} = a,
          {bx, by} = b,
          {x, y} <- [
            {ax - k * (bx - ax), ay - k * (by - ay)},
            {bx - k * (ax - bx), by - k * (ay - by)}
          ],
          x >= 0 and x < width and y >= 0 and y < height do
        {k == 1, {x, y}}
      end
    end)
    |> Enum.reduce({[], []}, fn {is_k1, point}, {acc1, acc2} ->
      acc2 = [point | acc2]
      acc1 = if is_k1, do: [point | acc1], else: acc1
      {acc1, acc2}
    end)
    |> Tuple.to_list()
    |> Enum.map(&MapSet.size(MapSet.new(&1)))
  end
end

input =
  File.stream!("8.in")
  |> Enum.map(&String.trim/1)
  |> Enum.map(&String.graphemes/1)

[part_1, part_2] = Main.solve(input)

IO.puts("Part 1: #{part_1}")
IO.puts("Part 2: #{part_2}")
