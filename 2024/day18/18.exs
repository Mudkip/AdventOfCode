Code.require_file("../../utils/grid.exs")

defmodule MemoryFallout do
  def simulate_fallout(grid, memory, steps) do
    memory
    |> Enum.take(steps)
    |> Enum.reduce(grid, fn pos, acc ->
      GridUtils.set_value(acc, pos, "#")
    end)
  end

  def simulate_with_cutoff_calc(grid, memory) do
    Enum.reduce_while(memory, {grid, nil}, fn pos, {current_grid, _} ->
      updated_grid = GridUtils.set_value(current_grid, pos, "#")
      path = GridUtils.shortest_path_bfs(updated_grid, {0, 0}, {70, 70}, ["."], :four)

      if path == nil do
        {:halt, pos}
      else
        {:cont, {updated_grid, nil}}
      end
    end)
  end
end

memory =
  File.stream!("18.in")
  |> Stream.map(&String.trim/1)
  |> Stream.map(&String.split(&1, ","))
  |> Stream.map(fn line ->
    line
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end)

part_1 =
  GridUtils.create(71, 71, ".")
  |> MemoryFallout.simulate_fallout(memory, 1024)
  |> GridUtils.shortest_path_bfs({0, 0}, {70, 70}, ["."], :four)
  |> Enum.count()
  |> Kernel.-(1)

{p2x, p2y} =
  GridUtils.create(71, 71, ".")
  |> MemoryFallout.simulate_with_cutoff_calc(memory)

IO.puts("Part 1: #{part_1}")
IO.puts("Part 2: #{p2x},#{p2y}")
