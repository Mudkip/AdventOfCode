safe_report = fn list ->
  chunks = Enum.chunk_every(list, 2, 1, :discard)

  diffs =
    Enum.map(chunks, fn pair ->
      List.first(pair) - List.last(pair)
    end)

  cond do
    Enum.all?(diffs, fn x -> x < 0 and x >= -3 end) -> true
    Enum.all?(diffs, fn x -> x > 0 and x <= 3 end) -> true
    true -> false
  end
end

input_data =
  File.stream!("2.in")
  |> Enum.map(fn line ->
    line
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end)

part_1 =
  input_data
  |> Enum.map(&safe_report.(&1))
  |> Enum.filter(& &1)
  |> Enum.count()

part_2 =
  input_data
  |> Enum.filter(fn report ->
    Enum.map(0..(length(report) - 1), fn index ->
      List.delete_at(report, index)
    end)
    |> Enum.map(&safe_report.(&1))
    |> Enum.any?(& &1)
  end)
  |> Enum.count()

IO.puts("Part 1: #{part_1}")
IO.puts("Part 2: #{part_2}")
