defmodule MonkeyBusiness do
  import Bitwise

  def iterate_secret(secret, n) do
    {secret, list} =
      Enum.reduce(1..n, {secret, [secret]}, fn _i, {code, list} ->
        s = iterate_secret(code)
        {s, [s | list]}
      end)

    {secret, Enum.reverse(list)}
  end

  def iterate_secret(secret) do
    secret
    |> then(fn s -> prune(mix(s, bsl(s, 6))) end)
    |> then(fn a -> prune(mix(a, bsr(a, 5))) end)
    |> then(fn b -> prune(mix(b, bsl(b, 11))) end)
  end

  defp mix(secret, to_mix) do
    bxor(secret, to_mix)
  end

  defp prune(secret) do
    rem(secret, 16_777_216)
  end

  def ones(number) do
    rem(number, 10)
  end

  def actual_prices(list) do
    list |> Enum.map(&ones/1)
  end

  def biggest_price_sequences(list) do
    list
    |> Stream.chunk_every(5, 1, :discard)
    |> Stream.map(fn [a, b, c, d, e] ->
      {
        {b - a, c - b, d - c, e - d},
        e
      }
    end)
    |> Enum.reverse()
    |> Map.new()
  end
end

secrets =
  File.read!("22.in")
  |> String.split()
  |> Enum.map(&String.to_integer/1)

secrets = secrets |> Enum.map(&MonkeyBusiness.iterate_secret(&1, 2000))

prices =
  secrets
  |> Enum.map(&elem(&1, 1))
  |> Enum.map(fn list -> Enum.map(list, &MonkeyBusiness.ones/1) end)

sequences = prices |> Enum.map(&MonkeyBusiness.biggest_price_sequences/1)

sequence_profits =
  sequences
  |> Enum.reduce(%{}, fn map, acc ->
    Map.merge(acc, map, fn _k, v1, v2 -> v1 + v2 end)
  end)

part_1 = secrets |> Enum.map(&elem(&1, 0)) |> Enum.sum()
part_2 = sequence_profits |> Enum.max_by(fn {_key, value} -> value end) |> elem(1)
IO.puts("Part 1: #{part_1}")
IO.puts("Part 2: #{part_2}")
