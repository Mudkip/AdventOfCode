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
    |> then(fn s -> bxor(s, s <<< 6) &&& 16_777_215 end)
    |> then(fn a -> bxor(a, a >>> 5) &&& 16_777_215 end)
    |> then(fn b -> bxor(b, b <<< 11) &&& 16_777_215 end)
  end

  def actual_prices(list) do
    list |> Enum.map(&rem(&1, 10))
  end

  def pack_differences(a, b, c, d) do
    <<a::4, b::4, c::4, d::4>>
  end

  def biggest_price_sequences(list) do
    list
    |> Stream.chunk_every(5, 1, :discard)
    |> Stream.map(fn [a, b, c, d, e] ->
      key = pack_differences(b - a, c - b, d - c, e - d)
      {key, e}
    end)
    |> Enum.reverse()
    |> Map.new()
  end
end

secrets =
  File.read!("22.in")
  |> String.split()
  |> Enum.map(&String.to_integer/1)
  |> Task.async_stream(fn secret -> MonkeyBusiness.iterate_secret(secret, 2000) end)
  |> Enum.map(fn {:ok, result} -> result end)

prices =
  secrets
  |> Enum.map(&elem(&1, 1))
  |> Enum.map(&MonkeyBusiness.actual_prices/1)

sequences =
  prices
  |> Task.async_stream(&MonkeyBusiness.biggest_price_sequences/1)
  |> Enum.map(fn {:ok, result} -> result end)

sequence_profits =
  sequences
  |> Enum.chunk_every(max(1, div(length(sequences), System.schedulers_online())))
  |> Task.async_stream(fn chunk ->
    Enum.reduce(chunk, %{}, fn map, acc ->
      Map.merge(acc, map, fn _k, v1, v2 -> v1 + v2 end)
    end)
  end)
  |> Enum.map(fn {:ok, result} -> result end)
  |> Enum.reduce(%{}, fn map, acc ->
    Map.merge(acc, map, fn _k, v1, v2 -> v1 + v2 end)
  end)

part_1 = secrets |> Enum.map(&elem(&1, 0)) |> Enum.sum()
part_2 = sequence_profits |> Enum.max_by(fn {_key, value} -> value end) |> elem(1)
IO.puts("Part 1: #{part_1}")
IO.puts("Part 2: #{part_2}")
