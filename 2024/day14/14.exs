defmodule WhizPalace do
  def simulate_guard_step({x, y, dx, dy}, max_x, max_y) do
    nx = Integer.mod(x + dx, max_x)
    ny = Integer.mod(y + dy, max_y)
    {nx, ny, dx, dy}
  end

  def group_into_quadrants(positions, max_x, max_y) do
    middle_x = div(max_x, 2)
    middle_y = div(max_y, 2)

    positions
    |> Enum.reject(fn {x, y, _, _} ->
      x == middle_x || y == middle_y
    end)
    |> Enum.group_by(fn {x, y, _, _} ->
      cond do
        x < middle_x && y < middle_y -> :top_left
        x > middle_x && y < middle_y -> :top_right
        x < middle_x && y > middle_y -> :bottom_left
        x > middle_x && y > middle_y -> :bottom_right
      end
    end)
  end

  def has_security_cluster?(positions, size) do
    positions_set =
      positions
      |> Enum.map(fn {x, y, _, _} -> {x, y} end)
      |> MapSet.new()

    Enum.any?(positions, fn {x, y, _, _} ->
      neighbors =
        for dx <- -1..1,
            dy <- -1..1,
            {dx, dy} != {0, 0} do
          MapSet.member?(positions_set, {x + dx, y + dy})
        end
        |> Enum.count(& &1)

      neighbors >= size * size - 1
    end)
  end
end

input =
  File.stream!("14.in")
  |> Enum.map(&String.trim/1)
  |> Enum.map(fn machine_str ->
    [x, y, dx, dy] = Regex.scan(~r/-?\d+/, machine_str) |> List.flatten()

    {
      String.to_integer(x),
      String.to_integer(y),
      String.to_integer(dx),
      String.to_integer(dy)
    }
  end)

part_1 =
  input
  |> Enum.map(fn guard ->
    Enum.reduce(1..100, guard, fn _, current_pos ->
      WhizPalace.simulate_guard_step(current_pos, 101, 103)
    end)
  end)
  |> WhizPalace.group_into_quadrants(101, 103)
  |> Map.values()
  |> Enum.map(&length/1)
  |> Enum.reduce(1, &(&1 * &2))

part_2 =
  Enum.reduce_while(1..10000, input, fn step, positions ->
    next_positions =
      Enum.map(positions, fn pos ->
        WhizPalace.simulate_guard_step(pos, 101, 103)
      end)

    cond do
      # Massive assumption that a cluster of 3 indicates that a
      # subset of robots are arranged in a christmas tree
      WhizPalace.has_security_cluster?(next_positions, 3) -> {:halt, step}
      step >= 10000 -> {:halt, "No cluster found"}
      true -> {:cont, next_positions}
    end
  end)

IO.puts("Part 1: #{part_1}")
IO.puts("Part 2: #{part_2}")
