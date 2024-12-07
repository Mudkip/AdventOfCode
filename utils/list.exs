defmodule ListUtils do
  def generate_permutations(chars, length) when length > 0 do
    do_permutations(chars, length)
  end

  defp do_permutations(_, 0), do: [[]]

  defp do_permutations(chars, length) do
    for char <- chars,
        rest <- do_permutations(chars, length - 1),
        do: [char | rest]
  end
end
