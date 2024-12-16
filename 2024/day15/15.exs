Code.require_file("../../utils/grid.exs")

defmodule Amazon do
  @directions %{
    "<" => {-1, 0},
    ">" => {1, 0},
    "^" => {0, -1},
    "v" => {0, 1}
  }

  def tell_employee_to_work(grid, movements) do
    movements
    |> Enum.reduce(grid, fn movement, current_grid ->
      make_move(movement, current_grid)
    end)
  end

  defp make_move(movement, grid) do
    worker_pos = GridUtils.find_symbol(grid, "@")
    {dx, dy} = @directions[movement]

    if can_move?(grid, worker_pos, dx, dy) do
      update_grid(grid, worker_pos, dx, dy)
    else
      grid
    end
  end

  defp can_move?(grid, {x, y}, dx, dy) do
    next_pos = {x + dx, y + dy}

    case GridUtils.get_value(grid, next_pos) do
      "." ->
        true

      "#" ->
        false

      nil ->
        false

      _ ->
        can_move?(grid, next_pos, dx, dy)
    end
  end

  defp update_grid(grid, {x, y}, dx, dy) do
    next_pos = {x + dx, y + dy}

    case GridUtils.get_value(grid, next_pos) do
      "." -> {:ok, grid}
      _ -> move_boxes(grid, next_pos, dx, dy)
    end
    |> case do
      {:ok, new_grid} ->
        new_grid
        |> GridUtils.set_value({x, y}, ".")
        |> GridUtils.set_value(next_pos, "@")

      {:cannot_move, old_grid} ->
        old_grid
    end
  end

  defp move_boxes(grid, current_box_pos, dx, dy) do
    {bx, by} = current_box_pos
    next_pos = {bx + dx, by + dy}

    case GridUtils.get_value(grid, current_box_pos) do
      "." ->
        {:ok, grid}

      "#" ->
        {:cannot_move, grid}

      nil ->
        {:cannot_move, grid}

      symbol ->
        if symbol in ["[", "]"] and dy != 0 do
          {offset, first_symbol, second_symbol} =
            case symbol do
              "[" -> {1, "[", "]"}
              "]" -> {-1, "]", "["}
            end

          other_pos = {bx + offset, by}
          next_other_pos = {bx + offset + dx, by + dy}

          case move_boxes(grid, next_pos, dx, dy) do
            {:ok, new_grid} ->
              case move_boxes(new_grid, next_other_pos, dx, dy) do
                {:ok, final_grid} ->
                  {:ok,
                   final_grid
                   |> GridUtils.set_value(next_pos, first_symbol)
                   |> GridUtils.set_value(next_other_pos, second_symbol)
                   |> GridUtils.set_value(current_box_pos, ".")
                   |> GridUtils.set_value(other_pos, ".")}

                {:cannot_move, _} ->
                  {:cannot_move, grid}
              end

            {:cannot_move, grid} ->
              {:cannot_move, grid}
          end
        else
          case move_boxes(grid, next_pos, dx, dy) do
            {:ok, new_grid} -> {:ok, new_grid |> GridUtils.set_value(next_pos, symbol)}
            {:cannot_move, grid} -> {:cannot_move, grid}
          end
        end
    end
  end

  def find_boxes(grid, char), do: GridUtils.find_all_symbols(grid, char)
  def gps_boxes(boxes), do: boxes |> Enum.map(fn {x, y} -> 100 * y + x end) |> Enum.sum()

  def switch_warehouse(grid) do
    grid
    |> Enum.map(fn row ->
      row
      |> Enum.flat_map(fn cell ->
        case cell do
          "#" -> ["#", "#"]
          "O" -> ["[", "]"]
          "." -> [".", "."]
          "@" -> ["@", "."]
        end
      end)
    end)
  end
end

[grid, movements] =
  File.read!("15.in")
  |> String.split("\n\n")

warehouse =
  grid
  |> String.split("\n")
  |> GridUtils.from_string()

movements =
  movements
  |> String.replace("\n", "")
  |> String.graphemes()

part_1 =
  Amazon.tell_employee_to_work(warehouse, movements)
  |> Amazon.find_boxes("O")
  |> Amazon.gps_boxes()

part_2 =
  warehouse
  |> Amazon.switch_warehouse()
  |> Amazon.tell_employee_to_work(movements)
  |> Amazon.find_boxes("[")
  |> Amazon.gps_boxes()

IO.puts("Part 1: #{part_1}")
IO.puts("Part 2: #{part_2}")
