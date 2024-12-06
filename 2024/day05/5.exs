defmodule PageRuleChecker do
  def check(rules, pages) do
    pages
    |> Enum.map(fn row ->
      row
      |> Enum.reduce({[], true}, fn page, {seen, valid} ->
        if length(seen) == 0 do
          {[page], true}
        else
          rules_for_page = Map.get(rules, page, MapSet.new())

          forbidden_seen? =
            Enum.any?(seen, fn seen_page ->
              MapSet.member?(rules_for_page, seen_page)
            end)

          {seen ++ [page], valid and not forbidden_seen?}
        end
      end)
    end)
  end

  def reorder(rules, pages) do
    Enum.sort(pages, fn a, b ->
      forbidden_before_b = Map.get(rules, b, MapSet.new())
      forbidden_before_a = Map.get(rules, a, MapSet.new())

      cond do
        MapSet.member?(forbidden_before_b, a) -> false
        MapSet.member?(forbidden_before_a, b) -> true
        true -> false
      end
    end)
  end
end

defmodule Main do
  def part_1(rules, pages) do
    PageRuleChecker.check(rules, pages)
    |> Enum.reduce(0, fn {pages, correct_order?}, total ->
      case correct_order? do
        true -> total + Enum.at(pages, div(length(pages), 2))
        _ -> total
      end
    end)
  end

  def part_2(rules, pages) do
    PageRuleChecker.check(rules, pages)
    |> Enum.map(fn {pages, valid?} ->
      if not valid? do
        reordered = PageRuleChecker.reorder(rules, pages)
        Enum.at(reordered, div(length(reordered), 2))
      else
        0
      end
    end)
    |> Enum.sum()
  end
end

[rules, pages] =
  File.read!("5.in")
  |> String.split("\n\n")

rules =
  rules
  |> String.split()
  |> Enum.map(fn str ->
    [first, second] = String.split(str, "|")
    {String.to_integer(first), String.to_integer(second)}
  end)
  |> Enum.reduce(%{}, fn {first, second}, acc ->
    Map.update(acc, first, MapSet.new([second]), fn existing ->
      MapSet.union(existing, MapSet.new([second]))
    end)
  end)

pages =
  pages
  |> String.split()
  |> Enum.map(fn row ->
    String.split(row, ",")
    |> Enum.map(&String.to_integer/1)
  end)

part_1 = Main.part_1(rules, pages)
part_2 = Main.part_2(rules, pages)

IO.puts("Part 1: #{part_1}")
IO.puts("Part 1: #{part_2}")
