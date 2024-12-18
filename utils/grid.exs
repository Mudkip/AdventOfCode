defmodule GridUtils do
  def extract_line(grid, x1, y1, x2, y2) do
    dx =
      cond do
        x2 > x1 -> 1
        x2 < x1 -> -1
        true -> 0
      end

    dy =
      cond do
        y2 > y1 -> 1
        y2 < y1 -> -1
        true -> 0
      end

    steps = max(abs(x2 - x1), abs(y2 - y1))

    0..steps
    |> Enum.map(fn step ->
      x = x1 + step * dx
      y = y1 + step * dy
      Enum.at(Enum.at(grid, y), x)
    end)
    |> Enum.join()
  end

  def count_until_symbol(grid, start_x, start_y, dx, dy, symbol) do
    max_y = length(grid) - 1
    max_x = length(Enum.at(grid, 0)) - 1

    result =
      Stream.iterate(0, &(&1 + 1))
      |> Enum.reduce_while(nil, fn steps, _acc ->
        x = start_x + steps * dx
        y = start_y + steps * dy

        cond do
          x < 0 or x > max_x or y < 0 or y > max_y ->
            {:halt, {steps - 1, true}}

          Enum.at(Enum.at(grid, y), x) == symbol ->
            {:halt, {steps - 1, false}}

          true ->
            {:cont, nil}
        end
      end)

    result
  end

  def find_symbol(grid, symbol) do
    grid
    |> Enum.with_index()
    |> Enum.find_value(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.find_value(fn {cell, x} ->
        if cell == symbol, do: {x, y}
      end)
    end)
  end

  def find_all_symbols(grid, symbol) do
    grid
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.filter(fn {cell, _x} -> cell == symbol end)
      |> Enum.map(fn {_cell, x} -> {x, y} end)
    end)
    |> MapSet.new()
  end

  def rotate_direction(dx, dy, rotation) do
    case {dx, dy, rotation} do
      # up -> right
      {0, -1, :right} -> {1, 0}
      # right -> down
      {1, 0, :right} -> {0, 1}
      # down -> left
      {0, 1, :right} -> {-1, 0}
      # left -> up
      {-1, 0, :right} -> {0, -1}
      # up -> left
      {0, -1, :left} -> {-1, 0}
      # left -> down
      {-1, 0, :left} -> {0, 1}
      # down -> right
      {0, 1, :left} -> {1, 0}
      # right -> up
      {1, 0, :left} -> {0, -1}
    end
  end

  def from_string(string) do
    string
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.graphemes/1)
  end

  def all_to_integer(grid) do
    grid
    |> Enum.map(fn row ->
      Enum.map(row, &String.to_integer/1)
    end)
  end

  def get_dimensions(grid) do
    height = length(grid)
    width = length(Enum.at(grid, 0))
    {width, height}
  end

  def get_value(grid, {x, y}) do
    grid |> Enum.at(y) |> Enum.at(x)
  end

  def set_value(grid, {x, y}, value) do
    List.update_at(grid, y, fn row ->
      List.update_at(row, x, fn _ -> value end)
    end)
  end

  def visualize(grid) do
    grid
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")
    |> IO.puts()

    grid
  end

  def create(width, height, symbol \\ ".") do
    List.duplicate(
      List.duplicate(symbol, width),
      height
    )
  end

  def shortest_path_bfs(grid, start, goal, walkable_values, movement_type \\ :four) do
    bfs([{start, [start]}], grid, goal, walkable_values, MapSet.new([start]), movement_type)
  end

  defp bfs([], _grid, _goal, _walkable_values, _visited, _movement_type), do: nil

  defp bfs([{current, path} | rest], grid, goal, walkable_values, visited, movement_type) do
    if current == goal do
      Enum.reverse(path)
    else
      neighbors = get_neighbors(current, grid, walkable_values, visited, movement_type)
      new_visited = MapSet.union(visited, MapSet.new(neighbors))
      new_paths = Enum.map(neighbors, fn neighbor -> {neighbor, [neighbor | path]} end)
      bfs(rest ++ new_paths, grid, goal, walkable_values, new_visited, movement_type)
    end
  end

  defp get_neighbors({x, y}, grid, walkable_values, visited, movement_type) do
    directions =
      case movement_type do
        :four -> [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]
        :eight -> [{0, 1}, {1, 0}, {0, -1}, {-1, 0}, {1, 1}, {1, -1}, {-1, 1}, {-1, -1}]
      end

    Enum.filter(directions, fn {dx, dy} ->
      new_pos = {x + dx, y + dy}

      within_bounds?(new_pos, grid) and
        not MapSet.member?(visited, new_pos) and
        Enum.member?(walkable_values, get_value(grid, new_pos))
    end)
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
  end

  defp within_bounds?({x, y}, grid) do
    {width, height} = get_dimensions(grid)
    x >= 0 and x < width and y >= 0 and y < height
  end
end
