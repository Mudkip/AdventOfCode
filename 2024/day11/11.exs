defmodule StoneWatcher do
  require Integer

  def blink(stone_counts) when is_map(stone_counts) do
    Enum.reduce(stone_counts, %{}, fn {stone, count}, acc ->
      digits = stone |> Integer.digits()

      new_stones =
        cond do
          stone == 0 ->
            [1]

          Integer.is_even(length(digits)) ->
            digits
            |> Enum.chunk_every(div(length(digits), 2))
            |> Enum.map(&Integer.undigits/1)

          true ->
            [stone * 2024]
        end

      Enum.reduce(new_stones, acc, fn new_stone, inner_acc ->
        Map.update(inner_acc, new_stone, count, &(count + &1))
      end)
    end)
  end

  def blink(stones) when is_list(stones) do
    stones
    |> Enum.frequencies()
    |> blink()
  end

  def blink(stones, n) when n <= 0, do: stones

  def blink(stones, n) do
    stones
    |> blink()
    |> blink(n - 1)
  end
end

stones =
  File.read!("11.in")
  |> String.trim()
  |> String.split()
  |> Enum.map(&String.to_integer/1)

part_1 =
  stones
  |> StoneWatcher.blink(25)
  |> Map.values()
  |> Enum.sum()

part_2 =
  stones
  |> StoneWatcher.blink(75)
  |> Map.values()
  |> Enum.sum()

IO.puts("Part 1: #{part_1}")
IO.puts("Part 1: #{part_2}")
