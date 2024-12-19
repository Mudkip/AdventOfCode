defmodule TowelDesigner do
  def can_construct(requirement, patterns) do
    do_construct(requirement, patterns, %{})
  end

  defp do_construct("", _patterns, memo), do: {1, memo}

  defp do_construct(requirement, patterns, memo) do
    case Map.get(memo, requirement) do
      nil ->
        result =
          patterns
          |> Enum.reduce({0, memo}, fn pattern, {count, current_memo} ->
            if String.starts_with?(requirement, pattern) do
              remaining =
                String.slice(requirement, String.length(pattern)..String.length(requirement))

              {ways, new_memo} = do_construct(remaining, patterns, current_memo)
              {count + ways, new_memo}
            else
              {count, current_memo}
            end
          end)

        {total_ways, final_memo} = result
        {total_ways, Map.put(final_memo, requirement, total_ways)}

      cached_result ->
        {cached_result, memo}
    end
  end

  def find_possible_requirements(requirements, patterns) do
    requirements_data =
      requirements
      |> Enum.map(fn req ->
        {ways, _} = can_construct(req, patterns)
        {req, ways}
      end)

    possible_count = requirements_data |> Enum.count(fn {_req, ways} -> ways > 0 end)
    total_ways = requirements_data |> Enum.map(&elem(&1, 1)) |> Enum.sum()

    {possible_count, total_ways}
  end
end

[patterns, requirements] = File.read!("19.in") |> String.split("\n\n")
patterns = patterns |> String.split(", ")
requirements = requirements |> String.split()

{possible_count, total_ways} = TowelDesigner.find_possible_requirements(requirements, patterns)

IO.puts("Part 1: #{possible_count}")
IO.puts("Part 2: #{total_ways}")
