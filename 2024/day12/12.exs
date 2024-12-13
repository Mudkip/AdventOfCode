Code.require_file("../../utils/grid.exs")

defmodule HappyFarmer do
  def region_explorer(grid) do
    for {row, y} <- Enum.with_index(grid),
        {symbol, x} <- Enum.with_index(row),
        reduce: {[], MapSet.new()} do
      {regions, visited} ->
        if Enum.member?(visited, {x, y}) do
          {regions, visited}
        else
          {points, area, perimeter, new_visited} = flood_fill(grid, {x, y}, symbol, visited)
          {[{symbol, area, perimeter, count_sides(points)} | regions], new_visited}
        end
    end
    |> elem(0)
  end

  defp flood_fill(grid, {x, y}, symbol, visited) do
    case MapSet.put(visited, {x, y}) do
      ^visited ->
        {[], 0, 0, visited}

      visited ->
        {width, height} = GridUtils.get_dimensions(grid)

        neighbors =
          for {dx, dy} <- [{0, -1}, {0, 1}, {-1, 0}, {1, 0}],
              nx = x + dx,
              ny = y + dy,
              nx >= 0 and nx < width and ny >= 0 and ny < height,
              GridUtils.get_value(grid, {nx, ny}) == symbol,
              do: {nx, ny}

        perimeter = 4 - length(neighbors)

        Enum.reduce(
          neighbors,
          {[{x, y}], 1, perimeter, visited},
          &process_neighbor(&1, &2, grid, symbol)
        )
    end
  end

  defp process_neighbor(neighbor, {points, area, perimeter, visited}, grid, symbol) do
    {npo, na, npe, nv} = flood_fill(grid, neighbor, symbol, visited)

    {points ++ npo, area + na, perimeter + npe, nv}
  end

  defp count_sides(points) do
    points
    |> Enum.map(fn {x, y} ->
      [
        {[{x - 1, y}, {x, y - 1}], nil},
        {[{x, y - 1}, {x + 1, y}], nil},
        {[{x - 1, y}, {x, y + 1}], nil},
        {[{x, y + 1}, {x + 1, y}], nil},
        {[{x - 1, y}, {x, y - 1}], {x - 1, y - 1}},
        {[{x, y - 1}, {x + 1, y}], {x + 1, y - 1}},
        {[{x - 1, y}, {x, y + 1}], {x - 1, y + 1}},
        {[{x, y + 1}, {x + 1, y}], {x + 1, y + 1}}
      ]
      |> Enum.count(fn {adjacent, diagonal} ->
        case diagonal do
          nil ->
            Enum.all?(adjacent, fn coord -> !Enum.member?(points, coord) end)

          diag ->
            Enum.all?(adjacent, fn coord -> Enum.member?(points, coord) end) and
              !Enum.member?(points, diag)
        end
      end)
    end)
    |> Enum.sum()
  end
end

farmland =
  File.stream!("12.in")
  |> GridUtils.from_string()

explored =
  farmland
  |> HappyFarmer.region_explorer()

part_1 =
  explored
  |> Enum.map(fn {_symbol, area, perimeter, _sides} -> area * perimeter end)
  |> Enum.sum()

part_2 =
  explored
  |> Enum.map(fn {_symbol, area, _perimeter, sides} -> area * sides end)
  |> Enum.sum()

IO.puts("Part 1: #{part_1}")
IO.puts("Part 1: #{part_2}")
