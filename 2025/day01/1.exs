{_, zero_crossings, zero_lands} =
  File.stream!("1.in")
  |> Enum.map(&String.trim/1)
  |> Enum.map(&String.split_at(&1, 1))
  |> Enum.reduce({50, 0, 0}, fn {d, v}, {acc, crossings, lands} ->
    amount = String.to_integer(v)

    total_zero_crossings =
      case d do
        "R" ->
          div(acc + amount, 100)

        "L" ->
          if acc == 0 do
            div(amount, 100)
          else
            if amount >= acc do
              div(amount - acc, 100) + 1
            else
              0
            end
          end
      end

    new_val =
      Integer.mod(
        case d do
          "L" -> acc - amount
          "R" -> acc + amount
        end,
        100
      )

    new_lands = if new_val == 0, do: lands + 1, else: lands
    new_crossings = crossings + total_zero_crossings

    {new_val, new_crossings, new_lands}
  end)

IO.puts("Part 1: #{zero_lands}")
IO.puts("Part 2: #{zero_crossings}")
