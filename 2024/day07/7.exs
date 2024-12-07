Code.require_file("../../utils/list.exs")

defmodule Main do
  def part_1(input) do
    input
    |> Enum.filter(&valid_expression?(&1, ["+", "*"]))
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  def part_2(input) do
    input
    |> Task.async_stream(fn tuple = {target, _} ->
      if valid_expression?(tuple, ["+", "*", "||"]), do: target, else: 0
    end)
    |> Enum.map(fn {:ok, result} -> result end)
    |> Enum.sum()
  end

  defp valid_expression?({target_total, numbers}, valid_operators) do
    operator_count = length(numbers) - 1
    operators = ListUtils.generate_permutations(valid_operators, operator_count)
    Enum.any?(operators, &(evaluate(numbers, &1) == target_total))
  end

  defp evaluate([first | rest], operators) do
    Enum.zip(operators, rest)
    |> Enum.reduce(first, &apply_operator/2)
  end

  defp apply_operator({"+", num}, acc), do: acc + num
  defp apply_operator({"*", num}, acc), do: acc * num

  defp apply_operator({"||", num}, acc) do
    "#{acc}#{num}"
    |> String.to_integer()
  end
end

input =
  File.stream!("7.in")
  |> Enum.map(&String.trim/1)
  |> Enum.map(fn row ->
    [left, right] = String.split(row, ": ")
    right = String.split(right, " ")
    right = Enum.map(right, &String.to_integer/1)
    {String.to_integer(left), right}
  end)

part_1 = Main.part_1(input)
part_2 = Main.part_2(input)

IO.puts("Part 1: #{part_1}")
IO.puts("Part 2: #{part_2}")
