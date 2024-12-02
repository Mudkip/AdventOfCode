nums = %{
  one: "1",
  two: "2",
  three: "3",
  four: "4",
  five: "5",
  six: "6",
  seven: "7",
  eight: "8",
  nine: "9"
}

replacements = %{
  one: "onee",
  two: "twoo",
  five: "fivee",
  seven: "sevenn",
  eight: "eightt",
  nine: "ninee"
}

part1 =
  File.stream!("1.in")
  |> Enum.map(&String.trim/1)
  |> Enum.map(&String.replace(&1, ~r/[^\d]/, ""))
  |> Enum.map(fn val -> if val != "", do: "#{String.first(val)}#{String.last(val)}", else: "0" end)
  |> Enum.map(&String.to_integer/1)
  |> Enum.sum()

part2 =
  File.stream!("1.in")
  |> Enum.map(&String.trim/1)
  |> Enum.map(fn line ->
    Map.keys(replacements)
    |> Enum.reduce(
      line,
      fn key, acc ->
        str_key = Atom.to_string(key)

        if String.contains?(line, str_key) do
          String.replace(acc, str_key, Map.get(replacements, key))
        else
          acc
        end
      end
    )
  end)
  |> Enum.map(fn line ->
    Map.keys(nums)
    |> Enum.reduce(
      line,
      fn key, acc ->
        String.replace(acc, Atom.to_string(key), Map.get(nums, key))
      end
    )
  end)
  |> Enum.map(&String.replace(&1, ~r/[^\d]/, ""))
  |> Enum.map(fn val -> if val != "", do: "#{String.first(val)}#{String.last(val)}", else: "0" end)
  |> Enum.map(&String.to_integer/1)
  |> Enum.sum()

IO.puts("Part 1: #{part1}")
IO.puts("Part 2: #{part2}")
