lines = File.stream!("6.in") |> Enum.map(&String.trim_trailing(&1, "\n"))
max_len = lines |> Enum.map(&String.length/1) |> Enum.max()

input =
  lines
  |> Enum.map(&(&1 |> String.pad_trailing(max_len) |> String.graphemes()))
  |> Enum.zip_with(& &1)
  |> Enum.chunk_by(fn col -> Enum.all?(col, &(&1 == " ")) end)
  |> Enum.reject(fn group -> Enum.all?(List.first(group), &(&1 == " ")) end)

problems_p1 =
  input
  |> Enum.map(fn problem_cols ->
    {num_rows, [op_row]} = problem_cols |> Enum.zip_with(& &1) |> Enum.split(-1)
    op = op_row |> Enum.reject(&(&1 == " ")) |> Enum.join()
    nums = num_rows |> Enum.map(&(&1 |> Enum.join() |> String.trim() |> String.to_integer()))

    {op, nums}
  end)

problems_p2 =
  input
  |> Enum.map(fn problem_cols ->
    op = problem_cols |> List.first() |> List.last()

    nums =
      problem_cols
      |> Enum.map(&(&1 |> Enum.drop(-1) |> Enum.reject(fn c -> c == " " end) |> Enum.join()))
      |> Enum.reject(&(&1 == ""))
      |> Enum.map(&String.to_integer/1)

    {op, nums}
  end)

apply_op = fn
  {"+", nums} -> Enum.sum(nums)
  {"*", nums} -> Enum.product(nums)
end

part_1 = problems_p1 |> Enum.map(apply_op) |> Enum.sum()
part_2 = problems_p2 |> Enum.map(apply_op) |> Enum.sum()

IO.puts("Part 1: #{part_1}")
IO.puts("Part 2: #{part_2}")
