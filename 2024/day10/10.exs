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

  def navigate(trailmap, {x, y}) do
    valid_neighbors(trailmap, {x, y})
    |> Enum.flat_map(fn {nx, ny} ->
      case GridUtils.get_value(trailmap, {nx, ny}) do
        9 -> [{x, y}]
        _ -> navigate(trailmap, {nx, ny})
      end
    end)
  end

  def score(navigation) do
    navigation |> MapSet.new() |> MapSet.size()
  end

  def rank(navigation) do
    navigation |> length()
  end

  defp valid_neighbors(trailmap, {x, y}) do
    {width, height} = GridUtils.get_dimensions(trailmap)
    current_value = GridUtils.get_value(trailmap, {x, y})

    [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
    |> Enum.filter(fn {nx, ny} ->
      nx >= 0 and nx < width and ny >= 0 and ny < height and
        GridUtils.get_value(trailmap, {nx, ny}) == current_value + 1
    end)
  end
end

grid =
  File.stream!("10.in")
  |> GridUtils.from_string()
  |> GridUtils.all_to_integer()

navigations =
  TrailExplorer.find_trailheads(grid)
  |> Enum.map(&TrailExplorer.navigate(grid, &1))

part_1 =
  navigations
  |> Enum.map(&TrailExplorer.score/1)
  |> Enum.sum()

part_2 =
  navigations
  |> Enum.map(&TrailExplorer.rank/1)
  |> Enum.sum()

IO.puts("Part 1: #{part_1}")
IO.puts("Part 2: #{part_2}")
