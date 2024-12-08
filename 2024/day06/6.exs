Code.require_file("../../utils/grid.exs")

defmodule Main do
  def next_state(input, {x, y, dx, dy}) do
    {steps, hit_boundary?} = GridUtils.count_until_symbol(input, x, y, dx, dy, "#")

    if hit_boundary? do
      nil
    else
      new_x = x + steps * dx
      new_y = y + steps * dy
      {new_dx, new_dy} = GridUtils.rotate_direction(dx, dy, :right)
      {new_x, new_y, new_dx, new_dy}
    end
  end

  # Floyd's Hare-Tortoise algorithm
  def has_cycle?(input, start_x, start_y, start_dx, start_dy) do
    initial_state = {start_x, start_y, start_dx, start_dy}

    result =
      Stream.iterate({initial_state, initial_state}, fn {tortoise, hare} ->
        tortoise_next = next_state(input, tortoise)
        hare_once = next_state(input, hare)

        case {tortoise_next, hare_once} do
          {nil, _} ->
            nil

          {_, nil} ->
            nil

          {t, h} ->
            hare_twice = next_state(input, h)

            case hare_twice do
              nil -> nil
              h2 -> {t, h2}
            end
        end
      end)
      |> Stream.drop(1)
      |> Stream.take_while(&(&1 != nil))
      |> Enum.reduce_while(false, fn {t, h}, _acc ->
        if t == h, do: {:halt, true}, else: {:cont, false}
      end)

    result
  end

  def test_position(input, test_x, test_y, {start_dx, start_dy}) do
    {sx, sy} = GridUtils.find_symbol(input, "^")

    if test_x == sx and test_y == sy do
      false
    else
      modified_input =
        List.update_at(input, test_y, fn row ->
          List.update_at(row, test_x, fn _ -> "#" end)
        end)

      has_cycle?(modified_input, sx, sy, start_dx, start_dy)
    end
  end

  def part_1(input) do
    {dx, dy} = {0, -1}
    {sx, sy} = GridUtils.find_symbol(input, "^")

    Stream.iterate({sx, sy, dx, dy, MapSet.new([{sx, sy}]), false}, fn {x, y, curr_dx, curr_dy,
                                                                        visited, done?} ->
      if done? do
        nil
      else
        {steps, exited_grid?} = GridUtils.count_until_symbol(input, x, y, curr_dx, curr_dy, "#")

        new_visited =
          Enum.reduce(1..steps, visited, fn step, acc ->
            visit_x = x + step * curr_dx
            visit_y = y + step * curr_dy
            MapSet.put(acc, {visit_x, visit_y})
          end)

        new_x = x + steps * curr_dx
        new_y = y + steps * curr_dy
        {new_dx, new_dy} = GridUtils.rotate_direction(curr_dx, curr_dy, :right)
        {new_x, new_y, new_dx, new_dy, new_visited, exited_grid?}
      end
    end)
    |> Stream.take_while(&(&1 != nil))
    |> Enum.at(-1)
    |> elem(4)
    |> MapSet.size()
  end

  def part_2(input) do
    max_y = length(input) - 1
    max_x = length(Enum.at(input, 0)) - 1

    positions =
      for y <- 0..max_y,
          x <- 0..max_x,
          Enum.at(Enum.at(input, y), x) == "." do
        {x, y}
      end

    positions
    |> Task.async_stream(fn {x, y} ->
      if test_position(input, x, y, {0, -1}), do: {x, y}, else: nil
    end)
    |> Stream.filter(fn {:ok, result} -> result != nil end)
    |> Enum.count()
  end
end

input =
  File.stream!("6.in")
  |> GridUtils.from_string()

part_1 = input |> Main.part_1()
part_2 = input |> Main.part_2()

IO.puts("Part 1: #{part_1}")
IO.puts("Part 2: #{part_2}")
