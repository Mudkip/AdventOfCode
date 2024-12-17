defmodule Debugger do
  def run(program, state) do
    execute(program, 0, state, [])
  end

  defp execute(program, ip, state, outputs) when ip >= length(program) do
    {state, Enum.reverse(outputs)}
  end

  defp execute(program, ip, state, outputs) do
    opcode = Enum.at(program, ip)
    operand = Enum.at(program, ip + 1)

    {new_state, new_ip, new_output} = process_instruction(opcode, operand, state, ip)

    outputs = if new_output != nil, do: [new_output | outputs], else: outputs
    execute(program, new_ip, new_state, outputs)
  end

  defp process_instruction(opcode, operand, state, ip) do
    case opcode do
      0 ->
        divisor = :math.pow(2, get_combo_value(operand, state)) |> round()
        {%{state | a: div(state.a, divisor)}, ip + 2, nil}

      1 ->
        {%{state | b: Bitwise.bxor(state.b, operand)}, ip + 2, nil}

      2 ->
        {%{state | b: rem(get_combo_value(operand, state), 8)}, ip + 2, nil}

      3 ->
        new_ip = if state.a != 0, do: operand, else: ip + 2
        {state, new_ip, nil}

      4 ->
        {%{state | b: Bitwise.bxor(state.b, state.c)}, ip + 2, nil}

      5 ->
        output = rem(get_combo_value(operand, state), 8)
        {state, ip + 2, output}

      6 ->
        divisor = :math.pow(2, get_combo_value(operand, state)) |> round()
        {%{state | b: div(state.a, divisor)}, ip + 2, nil}

      7 ->
        divisor = :math.pow(2, get_combo_value(operand, state)) |> round()
        {%{state | c: div(state.a, divisor)}, ip + 2, nil}
    end
  end

  defp get_combo_value(operand, state) do
    case operand do
      operand when operand <= 3 -> operand
      4 -> state.a
      5 -> state.b
      6 -> state.c
    end
  end

  def reverse_register_a(program) do
    Enum.reduce((length(program) - 1)..0, 0, fn itr, register_a ->
      register_a = register_a * 8

      Stream.iterate(register_a, &(&1 + 1))
      |> Enum.find(fn test_a ->
        {_, outputs} = Debugger.run(program, %{a: test_a, b: 0, c: 0})
        Enum.drop(program, itr) == outputs
      end)
    end)
  end
end

[registrar_strings, program_string] = File.read!("17.in") |> String.split("\n\n")

registrars =
  registrar_strings
  |> String.split()
  |> Enum.filter(&(&1 != "Register"))
  |> Enum.chunk_every(2)
  |> Enum.map(fn [reg, val] ->
    {String.downcase(String.trim(reg, ":")), String.to_integer(val)}
  end)
  |> Map.new(fn {reg, val} -> {String.to_atom(reg), val} end)

program =
  program_string
  |> String.replace_prefix("Program: ", "")
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)

{_, part_1} = Debugger.run(program, registrars)
part_2 = Debugger.reverse_register_a(program)

IO.puts("Part 1: #{Enum.join(part_1, ",")}")
IO.puts("Part 2: #{part_2}")
