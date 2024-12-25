Code.require_file("../../utils/list.exs")

defmodule LockpickingLawyer do
  def analyze(grids) do
    Enum.reduce(grids, {[], []}, fn grid, {keys, locks} ->
      type = if List.first(grid) |> String.starts_with?("....."), do: :key, else: :lock
      heights = count_heights(grid, type)

      case type do
        :key -> {keys ++ [heights], locks}
        :lock -> {keys, locks ++ [heights]}
      end
    end)
  end

  def count_heights(grid, type) do
    width = String.length(List.first(grid))
    height = length(grid) - 1

    for col <- 0..(width - 1) do
      range = case type do
        :key -> (height - 1)..0
        :lock -> 1..height
      end

      Enum.reduce_while(range, 0, fn row, acc ->
        char = Enum.at(grid, row) |> String.at(col)
        if char == "#", do: {:cont, acc + 1}, else: {:halt, acc}
      end)
    end
  end
end

{keys, locks} =
  File.read!("25.in")
  |> String.split("\n\n")
  |> Enum.map(&String.split(&1, "\n", trim: true))
  |> LockpickingLawyer.analyze()

valid_combinations =
  ListUtils.combinations(keys, locks)
  |> Enum.count(fn {k, l} ->
    Enum.zip(k, l) |> Enum.all?(fn {k_height, l_height} -> k_height + l_height <= 5 end)
  end)

IO.puts("Part 1: #{valid_combinations}")
