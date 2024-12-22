Mix.install([{:memoize, "~> 1.4"}])

defmodule KeypadCracker do
  use Memoize

  @numeric %{
    "0" => %{^: "2", >: "A"},
    "1" => %{>: "2", ^: "4"},
    "2" => %{v: "0", <: "1", >: "3", ^: "5"},
    "3" => %{<: "2", ^: "6", v: "A"},
    "4" => %{v: "1", >: "5", ^: "7"},
    "5" => %{v: "2", <: "4", >: "6", ^: "8"},
    "6" => %{v: "3", <: "5", ^: "9"},
    "7" => %{v: "4", >: "8"},
    "8" => %{v: "5", <: "7", >: "9"},
    "9" => %{v: "6", <: "8"},
    "A" => %{<: "0", ^: "3"}
  }

  @directional %{
    "^" => %{>: "A", v: "v"},
    "<" => %{>: "v"},
    "v" => %{<: "<", ^: "^", >: ">"},
    ">" => %{<: "v", ^: "A"},
    "A" => %{<: "^", v: ">"}
  }

  def find_shortest_paths(start, target, keypad) do
    find_shortest_paths(
      start,
      target,
      keypad,
      {:queue.from_list([{start, []}]), MapSet.new(), nil, []}
    )
  end

  def find_shortest_paths(start, target, keypad, {queue, seen, shortest, results}) do
    case :queue.out(queue) do
      {:empty, _} ->
        results

      {{:value, {^target, path}}, queue} ->
        new_shortest = shortest || length(path)

        if length(path) == new_shortest do
          find_shortest_paths(
            start,
            target,
            keypad,
            {queue, seen, new_shortest, [Enum.join(path ++ ["A"]) | results]}
          )
        else
          find_shortest_paths(start, target, keypad, {queue, seen, shortest, results})
        end

      {{:value, {_current, path}}, queue} when shortest != nil and length(path) >= shortest ->
        find_shortest_paths(start, target, keypad, {queue, seen, shortest, results})

      {{:value, {current, path}}, queue} ->
        {new_queue, new_seen} =
          Enum.reduce(keypad[current] || [], {queue, MapSet.put(seen, current)}, fn {dir, next},
                                                                                    {q, s} ->
            if MapSet.member?(s, next),
              do: {q, s},
              else: {:queue.in({next, path ++ [Atom.to_string(dir)]}, q), s}
          end)

        find_shortest_paths(start, target, keypad, {new_queue, new_seen, shortest, results})
    end
  end

  defmemo calculate_complexity(sequence, level, keypad \\ @numeric) do
    sequence
    |> String.graphemes()
    |> List.insert_at(0, "A")
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(0, fn [u, v], acc ->
      paths = find_shortest_paths(u, v, keypad)

      path_length =
        if level == 0,
          do: paths |> Enum.min_by(&String.length/1) |> String.length(),
          else:
            paths |> Enum.map(&calculate_complexity(&1, level - 1, @directional)) |> Enum.min()

      acc + path_length
    end)
  end

  def crack(code) do
    n = Regex.replace(~r/\D/, code, "") |> String.to_integer()
    {calculate_complexity(code, 2) * n, calculate_complexity(code, 25) * n}
  end
end

{part_1, part_2} =
  File.read!("21.in")
  |> String.split()
  |> Enum.map(&KeypadCracker.crack/1)
  |> Enum.reduce({0, 0}, fn {a, b}, {x, y} -> {x + a, y + b} end)

IO.puts("Part 1: #{part_1}")
IO.puts("Part 2: #{part_2}")
