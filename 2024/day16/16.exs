Code.require_file("../../utils/grid.exs")

defmodule MazeRunner do
  def find_best_path(maze) do
    start = GridUtils.find_symbol(maze, "S")
    goal = GridUtils.find_symbol(maze, "E")
    {width, height} = GridUtils.get_dimensions(maze)

    initial_state = {start, {1, 0}, 0}
    initial_path = MapSet.new([start])
    visited = %{}
    queue = [{0, initial_state, initial_path}]

    {min_score, optimal_paths} =
      find_path(queue, visited, maze, goal, width, height, [], :infinity)

    optimal_tiles =
      optimal_paths
      |> Enum.reduce(MapSet.new(), fn path, acc -> MapSet.union(acc, path) end)

    {min_score, MapSet.size(optimal_tiles)}
  end

  defp find_path([], _visited, _maze, _goal, _width, _height, paths, min_score),
    do: {min_score, paths}

  defp find_path(queue, visited, maze, goal, width, height, paths, min_score) do
    [{cost, state, path} | rest] = queue
    {{x, y}, direction, _} = state
    state_key = {x, y, direction}

    cond do
      min_score != :infinity and cost > min_score ->
        find_path(rest, visited, maze, goal, width, height, paths, min_score)

      {x, y} == goal ->
        if cost < min_score do
          find_path(rest, visited, maze, goal, width, height, [path], cost)
        else
          find_path(rest, visited, maze, goal, width, height, [path | paths], min_score)
        end

      Map.get(visited, state_key, :infinity) < cost ->
        find_path(rest, visited, maze, goal, width, height, paths, min_score)

      true ->
        visited = Map.put(visited, state_key, cost)
        next_moves = get_valid_moves({x, y}, direction, maze, width, height)

        queue =
          Enum.reduce(next_moves, rest, fn {new_pos, new_dir, move_cost}, acc ->
            new_cost = cost + move_cost
            new_path = MapSet.put(path, new_pos)
            insert_sorted(acc, {new_cost, {new_pos, new_dir, new_cost}, new_path})
          end)

        find_path(queue, visited, maze, goal, width, height, paths, min_score)
    end
  end

  defp insert_sorted([], item), do: [item]

  defp insert_sorted([{cost, _, _} = h | t] = list, {new_cost, _, _} = item) do
    if new_cost <= cost do
      [item | list]
    else
      [h | insert_sorted(t, item)]
    end
  end

  defp get_valid_moves({x, y}, {dx, dy}, maze, width, height) do
    {left_dx, left_dy} = GridUtils.rotate_direction(dx, dy, :left)
    {right_dx, right_dy} = GridUtils.rotate_direction(dx, dy, :right)

    moves = [
      {{x + dx, y + dy}, {dx, dy}, 1},
      {{x + left_dx, y + left_dy}, {left_dx, left_dy}, 1001},
      {{x + right_dx, y + right_dy}, {right_dx, right_dy}, 1001}
    ]

    Enum.filter(moves, fn {{new_x, new_y}, _, _} ->
      new_x >= 0 and new_x < width and new_y >= 0 and new_y < height and
        GridUtils.get_value(maze, {new_x, new_y}) != "#"
    end)
  end
end

maze = File.stream!("16.in") |> GridUtils.from_string()
{part_1, part_2} = MazeRunner.find_best_path(maze)

IO.puts("Part 1: #{part_1}")
IO.puts("Part 2: #{part_2}")
