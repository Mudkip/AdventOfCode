Code.require_file("../../utils/grid.exs")

defmodule GridSearcher do
  @directions [
    {0, 1},
    {1, 0},
    {0, -1},
    {-1, 0},
    {1, 1},
    {1, -1},
    {-1, 1},
    {-1, -1}
  ]

  def search_word(grid, string_to_find, x, y) do
    steps = String.length(string_to_find) - 1
    grid_height = length(grid)
    grid_width = length(Enum.at(grid, 0))

    Enum.sum(
      Enum.map(@directions, fn {dx, dy} ->
        end_x = x + dx * steps
        end_y = y + dy * steps

        if end_x >= 0 and end_x < grid_width and end_y >= 0 and end_y < grid_height do
          line = GridUtils.extract_line(grid, x, y, end_x, end_y)
          if line == string_to_find, do: 1, else: 0
        else
          0
        end
      end)
    )
  end

  def search_x(grid, string_to_find, x, y) do
    length = String.length(string_to_find)
    diff = div(length - 1, 2)

    if y - diff < 0 or x - diff < 0 or y + diff >= length(grid) or
         x + diff >= length(Enum.at(grid, 0)) do
      false
    else
      left_diagonal = GridUtils.extract_line(grid, x - diff, y - diff, x + diff, y + diff)
      right_diagonal = GridUtils.extract_line(grid, x + diff, y - diff, x - diff, y + diff)

      found_in_left =
        string_to_find == left_diagonal or string_to_find == String.reverse(left_diagonal)

      found_in_right =
        string_to_find == right_diagonal or string_to_find == String.reverse(right_diagonal)

      found_in_left and found_in_right
    end
  end
end

defmodule Main do
  def part_1(grid) do
    Enum.map(0..(length(grid) - 1), fn row_y ->
      row = Enum.at(grid, row_y)

      Enum.map(0..(length(row) - 1), fn row_x ->
        GridSearcher.search_word(grid, "XMAS", row_x, row_y)
      end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end

  def part_2(grid) do
    Enum.map(0..(length(grid) - 1), fn y ->
      row = Enum.at(grid, y)

      Enum.map(0..(length(row) - 1), fn x ->
        GridSearcher.search_x(grid, "MAS", x, y)
      end)
    end)
    |> List.flatten()
    |> Enum.filter(& &1)
    |> Enum.count()
  end
end

input =
  File.stream!("4.in")
  |> Enum.map(&String.trim/1)
  |> Enum.map(&String.graphemes/1)

part_1 = input |> Main.part_1()
part_2 = input |> Main.part_2()

IO.puts("Part 1: #{part_1}")
IO.puts("Part 2: #{part_2}")
