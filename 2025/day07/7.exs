Code.require_file("../../utils/grid.exs")

defmodule TachyonManifold do
  def solve(grid) do
    {start_x, start_y} = GridUtils.find_symbol(grid, "S")
    {width, height} = GridUtils.get_dimensions(grid)

    %{start_x => 1}
    |> simulate(grid, start_y + 1, 0, width, height)
  end

  defp simulate(timelines, _grid, y, splits, _width, height)
       when y >= height or map_size(timelines) == 0 do
    {splits, timelines |> Map.values() |> Enum.sum()}
  end

  defp simulate(timelines, grid, y, splits, width, height) do
    {new_timelines, new_splits} =
      Enum.reduce(timelines, {%{}, 0}, fn {x, count}, {acc, split_count} ->
        case GridUtils.get_value(grid, {x, y}) do
          "^" ->
            acc = add_if_valid(acc, x - 1, count, width)
            acc = add_if_valid(acc, x + 1, count, width)
            {acc, split_count + 1}

          _ ->
            {Map.update(acc, x, count, &(&1 + count)), split_count}
        end
      end)

    simulate(new_timelines, grid, y + 1, splits + new_splits, width, height)
  end

  defp add_if_valid(map, x, count, width) when x >= 0 and x < width do
    Map.update(map, x, count, &(&1 + count))
  end

  defp add_if_valid(map, _x, _count, _width), do: map
end

{part_1, part_2} = "7.in" |> File.stream!() |> GridUtils.from_string() |> TachyonManifold.solve()

IO.puts("Part 1: #{part_1}")
IO.puts("Part 2: #{part_2}")
