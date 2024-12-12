Code.require_file("../../utils/grid.exs")

defmodule TrailExplorer do
  def find_trailheads(trailmap) do
    for {row, y} <- Enum.with_index(trailmap),
        {symbol, x} <- Enum.with_index(row),
        symbol == 0,
        reduce: [] do
      acc -> [{x, y} | acc]
    end
    |> Enum.reverse()
  end

  def score_trailhead(trailmap, start_pos) do
    score_trailhead(trailmap, start_pos, MapSet.new(), MapSet.new()) |> MapSet.size()
  end

  defp valid_neighbors({x, y}, current_value, {width, height}, trailmap) do
    [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
    |> Enum.filter(fn {nx, ny} ->
      nx >= 0 and nx < width and ny >= 0 and ny < height and
        GridUtils.get_value(trailmap, {nx, ny}) == current_value + 1
    end)
  end

  defp score_trailhead(trailmap, {x, y}, visited, nines) do
    {width, height} = GridUtils.get_dimensions(trailmap)
    current_value = GridUtils.get_value(trailmap, {x, y})

    cond do
      GridUtils.get_value(trailmap, {x, y}) == 9 ->
        MapSet.put(nines, {x, y})

      MapSet.member?(visited, {x, y}) ->
        nines

      true ->
        visited = MapSet.put(visited, {x, y})

        valid_neighbors({x, y}, current_value, {width, height}, trailmap)
        |> Enum.reduce(nines, fn pos, acc ->
          score_trailhead(trailmap, pos, visited, acc)
        end)
    end
  end

  def rate_trailhead(trailmap, start_pos) do
    rate_trailhead(trailmap, start_pos, MapSet.new())
  end

  defp rate_trailhead(trailmap, {x, y}, visited) do
    {width, height} = GridUtils.get_dimensions(trailmap)

    if x < 0 or x >= width or y < 0 or y >= height or MapSet.member?(visited, {x, y}) do
      0
    else
      current_value = GridUtils.get_value(trailmap, {x, y})
      visited = MapSet.put(visited, {x, y})

      cond do
        current_value == 9 ->
          1

        current_value < 0 ->
          0

        true ->
          valid_neighbors({x, y}, current_value, {width, height}, trailmap)
          |> Enum.map(fn pos -> rate_trailhead(trailmap, pos, visited) end)
          |> Enum.sum()
      end
    end
  end
end

grid =
  File.stream!("10.in")
  |> GridUtils.from_string()
  |> GridUtils.all_to_integer()

trailheads = TrailExplorer.find_trailheads(grid)

part_1 =
  trailheads
  |> Enum.map(&TrailExplorer.score_trailhead(grid, &1))
  |> Enum.sum()

part_2 =
  trailheads
  |> Enum.map(&TrailExplorer.rate_trailhead(grid, &1))
  |> Enum.sum()

IO.puts("Part 1: #{part_1}")
IO.puts("Part 2: #{part_2}")
