defmodule GridUtils do
  def extract_line(grid, x1, y1, x2, y2) do
    dx = cond do
      x2 > x1 -> 1
      x2 < x1 -> -1
      true -> 0
    end

    dy = cond do
      y2 > y1 -> 1
      y2 < y1 -> -1
      true -> 0
    end

    steps = max(abs(x2 - x1), abs(y2 - y1))

    0..steps
    |> Enum.map(fn step ->
      x = x1 + (step * dx)
      y = y1 + (step * dy)
      Enum.at(Enum.at(grid, y), x)
    end)
    |> Enum.join()
  end
end
