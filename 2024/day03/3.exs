defmodule Switch do
  defstruct state: :empty, open: true, prepare: nil

  @state_transitions %{
    empty: %{entry: "d", next_state: :d},
    d: %{entry: "o", next_state: :o},
    o: %{entry: "n", next_state: :n},
    n: %{entry: "'", next_state: :quote},
    quote: %{entry: "t", next_state: :t}
  }

  def read_token(%Switch{state: state} = switch, entry: "(") when state in [:o, :t] do
    %Switch{switch | state: :lb}
  end

  def read_token(%Switch{state: :lb} = switch, entry: ")") do
    %Switch{switch | state: :empty, open: switch.prepare == :open}
  end

  def read_token(%Switch{} = switch, entry: entry) do
    case Map.get(@state_transitions, switch.state) do
      %{entry: ^entry, next_state: next_state} ->
        prepare =
          cond do
            next_state == :o -> :open
            next_state == :t -> :close
            true -> switch.prepare
          end

        %Switch{switch | state: next_state, prepare: prepare}

      _ ->
        switch
    end
  end
end

defmodule Multiplier do
  defstruct [:x, :y, state: :empty]

  @state_transitions %{
    empty: %{entry: "m", next_state: :m},
    m: %{entry: "u", next_state: :u},
    u: %{entry: "l", next_state: :l},
    l: %{entry: "(", next_state: :lb},
    x: %{entry: ",", next_state: :y}
  }

  def read_token(%Multiplier{state: state} = multiplier, entry: entry)
      when is_integer(entry) and state in [:lb, :x, :y] do
    {field, next_state} =
      case state do
        :lb -> {:x, :x}
        :x -> {:x, :x}
        :y -> {:y, :y}
      end

    current = Map.get(multiplier, field) || 0
    new_num = current * 10 + entry
    multiplier = Map.put(multiplier, field, new_num)
    {:ok, %Multiplier{multiplier | state: next_state}}
  end

  def read_token(%Multiplier{state: :y} = multiplier, entry: ")") do
    {:ok, multiplier.x * multiplier.y}
  end

  def read_token(%Multiplier{} = multiplier, entry: entry) do
    case Map.get(@state_transitions, multiplier.state) do
      %{entry: ^entry, next_state: next_state} ->
        {:ok, %Multiplier{multiplier | state: next_state}}

      _ ->
        {:error}
    end
  end
end

defmodule Main do
  def parse_char(char) do
    case Integer.parse(char) do
      {number, ""} -> number
      _ -> char
    end
  end

  def handle_multiplier(multiplier, read_char, open, results) do
    case Multiplier.read_token(multiplier, entry: read_char) do
      {:ok, %Multiplier{} = new_state} -> {results, new_state}
      {:ok, result} when is_integer(result) and open -> {[result | results], %Multiplier{}}
      {:ok, result} when is_integer(result) -> {results, %Multiplier{}}
      {:error} -> {results, %Multiplier{}}
    end
  end

  def part1(input) do
    input
    |> Enum.reduce({[], %Multiplier{}}, fn char, {results, multiplier} ->
      handle_multiplier(multiplier, parse_char(char), true, results)
    end)
    |> elem(0)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Enum.reduce({[], %Multiplier{}, %Switch{}}, fn char, {results, multiplier, switch} ->
      read_char = parse_char(char)

      updated_switch = Switch.read_token(switch, entry: read_char)

      {new_results, new_multiplier} =
        handle_multiplier(multiplier, read_char, updated_switch.open, results)

      {new_results, new_multiplier, updated_switch}
    end)
    |> elem(0)
    |> Enum.sum()
  end
end

input =
  File.read!("3.in")
  |> String.graphemes()

part_1 = input |> Main.part1()
part_2 = input |> Main.part2()

IO.puts("Part 1: #{part_1}")
IO.puts("Part 2: #{part_2}")
