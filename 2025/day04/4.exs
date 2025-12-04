Code.require_file("../../utils/grid.exs")

defmodule PaperFactoryMapper do
  def map(grid, first_count \\ nil, total_count \\ 0) do
    to_remove =
      GridUtils.each_cell(grid)
      |> Enum.filter(fn {{x, y}, cell} ->
        cell == "@" and
          length(GridUtils.get_neighbors({x, y}, grid, ["@"], MapSet.new(), :eight)) < 4
      end)
      |> Enum.map(fn {pos, _cell} -> pos end)

    if to_remove == [] do
      {first_count || 0, total_count}
    else
      new_grid =
        Enum.reduce(to_remove, grid, fn pos, acc ->
          GridUtils.set_value(acc, pos, ".")
        end)

      removed = length(to_remove)
      map(new_grid, first_count || removed, total_count + removed)
    end
  end
end

{part_1, part_2} =
  File.stream!("4.in")
  |> GridUtils.from_string()
  |> PaperFactoryMapper.map()

IO.puts("Part 1: #{first}")
IO.puts("Part 2: #{total}")
