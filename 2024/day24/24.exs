defmodule WireTracer do
  def simulate({initial_values, gates}) do
    simulate_gates(gates, initial_values)
  end

  defp simulate_gates(gates, values) do
    result = evaluate_all_gates(gates, values)

    if result == values do
      result
    else
      simulate_gates(gates, result)
    end
  end

  defp evaluate_all_gates(gates, values) do
    Enum.reduce(gates, values, fn gate, acc ->
      case evaluate_gate(gate, acc) do
        {:ok, wire, value} -> Map.put(acc, wire, value)
        :skip -> acc
      end
    end)
  end

  defp evaluate_gate({op, in1, in2, output}, values) do
    case {values[in1], values[in2]} do
      {nil, _} -> :skip
      {_, nil} -> :skip
      {v1, v2} ->
        result = case op do
          :and -> Bitwise.band(v1, v2)
          :or -> Bitwise.bor(v1, v2)
          :xor -> Bitwise.bxor(v1, v2)
        end
        {:ok, output, result}
    end
  end

  def get_result(values) do
    values
    |> Enum.filter(fn {<<"z", _::binary>>, _} -> true; _ -> false end)
    |> Enum.sort_by(fn {wire, _} -> wire end, :desc)
    |> Enum.map(&elem(&1, 1))
    |> Enum.join()
    |> String.to_integer(2)
  end

  def debug_bits(initial_map, gates) do
    num_bits = 45

    for bit <- 0..(num_bits - 1) do
      test_vals =
        Enum.reduce(0..(num_bits - 1), initial_map, fn pos, acc ->
          acc
          |> Map.put("x#{String.pad_leading("#{pos}", 2, "0")}", 0)
          |> Map.put("y#{String.pad_leading("#{pos}", 2, "0")}", if(pos == bit, do: 1, else: 0))
        end)

      result = simulate({test_vals, gates}) |> get_result()
      expected = Bitwise.bsl(1, bit)

      if result != expected do
        IO.puts("wrong bit #{bit}")
      end
    end
  end
end

[initial_values, gates] =
  File.read!("24.in")
  |> String.split("\n\n")
  |> Enum.map(&String.split(&1, "\n", trim: true))

initial_map =
  initial_values
  |> Enum.map(fn line ->
    [wire, value] = String.split(line, ": ")
    {wire, String.to_integer(value)}
  end)
  |> Map.new()

gates =
  gates
  |> Enum.map(fn line ->
    [in1, op, in2, "->", output] = String.split(line)
    {String.to_atom(String.downcase(op)), in1, in2, output}
  end)

part_1 =
  WireTracer.simulate({initial_map, gates})
  |> WireTracer.get_result()

IO.puts("Part 1: #{part_1}")

# Part 2
IO.puts("Part 2 wrong bits:")
WireTracer.debug_bits(initial_map, gates)
