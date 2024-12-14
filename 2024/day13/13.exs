defmodule ArcadePlayer do
  def optimize_claw({a1, a2, b1, b2, c1, c2}) do
    # https://en.wikipedia.org/wiki/Cramer%27s_rule
    denominator = a1 * b2 - b1 * a2
    x = (c1 * b2 - b1 * c2) / denominator
    y = (a1 * c2 - c1 * a2) / denominator

    if x == trunc(x) and y == trunc(y) and x >= 0 and y >= 0 do
      {trunc(x), trunc(y)}
    else
      nil
    end
  end

  def calculate_tokens(nil), do: 0
  def calculate_tokens({x, y}), do: 3 * x + y
end

machines =
  File.read!("13.in")
  |> String.trim()
  |> String.split("\n\n")
  |> Enum.map(fn machine_str ->
    [a1, a2, b1, b2, c1, c2] = Regex.scan(~r/\d+/, machine_str) |> List.flatten()

    {
      String.to_integer(a1),
      String.to_integer(a2),
      String.to_integer(b1),
      String.to_integer(b2),
      String.to_integer(c1),
      String.to_integer(c2)
    }
  end)

part_1 =
  machines
  |> Enum.map(&ArcadePlayer.optimize_claw/1)
  |> Enum.map(&ArcadePlayer.calculate_tokens/1)
  |> Enum.sum()

part_2 =
  machines
  |> Enum.map(fn {a1, a2, b1, b2, c1, c2} ->
    {a1, a2, b1, b2, c1 + 10_000_000_000_000, c2 + 10_000_000_000_000}
  end)
  |> Enum.map(&ArcadePlayer.optimize_claw/1)
  |> Enum.map(&ArcadePlayer.calculate_tokens/1)
  |> Enum.sum()

IO.puts("Part 1: #{part_1}")
IO.puts("Part 2: #{part_2}")
