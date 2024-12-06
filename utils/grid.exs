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
end
