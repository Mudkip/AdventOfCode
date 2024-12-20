Code.require_file("../../utils/grid.exs")

defmodule GridProblemNumber20 do
  def flood_fill(grid, start) do
    flood_fill_helper([{start, 0}], %{start => 0}, grid)
  end

  defp flood_fill_helper([], distances, _grid), do: distances

  defp flood_fill_helper([{pos, dist} | rest], distances, grid) do
    neighbors =
      get_valid_neighbors(grid, pos)
      |> Enum.reject(&Map.has_key?(distances, &1))
      |> Enum.map(fn pos -> {pos, dist + 1} end)

    new_distances = Map.merge(distances, Map.new(neighbors))
    new_queue = rest ++ neighbors

    flood_fill_helper(new_queue, new_distances, grid)
  end

  defp get_valid_neighbors(grid, {x, y}) do
    [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
    |> Enum.filter(fn pos ->
      case GridUtils.get_value(grid, pos) do
        nil -> false
        "#" -> false
        _ -> true
      end
    end)
  end

  def count_shortcuts(distances, max_distance) do
    distances_list = Map.to_list(distances) |> Enum.sort_by(fn {_pos, dist} -> dist end)

    for {{x1, y1}, dist1} <- distances_list,
        {{x2, y2}, dist2} <- distances_list,
        dist2 > dist1,
        manhattan = abs(x2 - x1) + abs(y2 - y1),
        manhattan <= max_distance,
        dist2 - dist1 - manhattan >= 100,
        reduce: 0 do
      acc -> acc + 1
    end
  end
end

grid = File.stream!("20.in") |> GridUtils.from_string()
start = GridUtils.find_symbol(grid, "S")
distances = GridProblemNumber20.flood_fill(grid, start)

part1 = GridProblemNumber20.count_shortcuts(distances, 2)
part2 = GridProblemNumber20.count_shortcuts(distances, 20)

IO.puts("Part 1: #{part1}")
IO.puts("Part 2: #{part2}")
