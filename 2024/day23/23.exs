defmodule LANParty do
  def build_graph(edges) do
    edges
    |> Enum.reduce(%{}, fn [a, b], acc ->
      acc
      |> Map.update(a, MapSet.new([b]), &MapSet.put(&1, b))
      |> Map.update(b, MapSet.new([a]), &MapSet.put(&1, a))
    end)
  end

  def find_triplets(graph) do
    nodes = Map.keys(graph)

    for a <- nodes,
        b <- MapSet.to_list(Map.get(graph, a)),
        c <- MapSet.to_list(Map.get(graph, b)),
        MapSet.member?(Map.get(graph, a), c) do
      MapSet.new([a, b, c])
    end
    |> MapSet.new()
  end

  def find_lan_party(graph) do
    nodes = Map.keys(graph)

    bron_kerbosch(graph, MapSet.new(), MapSet.new(nodes), MapSet.new())
    |> Enum.max_by(&MapSet.size/1)
  end

  # https://en.wikipedia.org/wiki/Bron-Kerbosch_algorithm
  defp bron_kerbosch(graph, r, p, x) do
    if MapSet.size(p) == 0 && MapSet.size(x) == 0 do
      [r]
    else
      u = choose_pivot(graph, MapSet.union(p, x))
      n_u = Map.get(graph, u, MapSet.new())

      p
      |> MapSet.difference(n_u)
      |> Enum.reduce([], fn v, acc ->
        n_v = Map.get(graph, v, MapSet.new())

        acc ++
          bron_kerbosch(
            graph,
            MapSet.put(r, v),
            MapSet.intersection(p, n_v),
            MapSet.intersection(x, n_v)
          )
      end)
    end
  end

  defp choose_pivot(graph, nodes) do
    Enum.max_by(nodes, fn node ->
      Map.get(graph, node, MapSet.new()) |> MapSet.size()
    end)
  end
end

input =
  File.stream!("23.in")
  |> Enum.map(&String.trim/1)
  |> Enum.map(&String.split(&1, "-"))

graph = LANParty.build_graph(input)
triplets = LANParty.find_triplets(graph)

part_1 =
  triplets
  |> Enum.filter(fn triplet ->
    Enum.any?(triplet, &(String.first(&1) == "t"))
  end)
  |> Enum.count()

IO.puts("Part 1: #{part_1}")

part_2 =
  LANParty.find_lan_party(graph)
  |> Enum.sort()
  |> Enum.join(",")

IO.puts("Part 2: #{part_2}")
