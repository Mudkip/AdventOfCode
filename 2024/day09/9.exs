defmodule DiskUtils do
  require Integer

  def defragment(disk) do
    defragment(disk, 0, length(disk) - 1)
  end

  defp defragment(disk, left, right) when left >= right do
    disk
  end

  defp defragment(disk, left, right) do
    left_blob = Enum.at(disk, left)
    right_blob = Enum.at(disk, right)

    case {left_blob, right_blob} do
      {{:file, _, _}, _} ->
        defragment(disk, left + 1, right)

      {{:empty, _}, {:empty, _}} ->
        defragment(disk, left, right - 1)

      {{:empty, 0}, _} ->
        {_, disk} = List.pop_at(disk, left)
        defragment(disk, left, right)

      {{:empty, empty_size}, {:file, file_size, file_id}} ->
        diff = empty_size - file_size

        cond do
          diff == 0 ->
            List.replace_at(disk, left, {:file, file_size, file_id})
            |> List.replace_at(right, {:empty, file_size})
            |> defragment(left + 1, right - 1)

          diff > 0 ->
            List.replace_at(disk, left, {:file, file_size, file_id})
            |> List.replace_at(right, {:empty, file_size})
            |> List.insert_at(left + 1, {:empty, diff})
            |> defragment(left + 1, right - 1)

          diff < 0 ->
            List.replace_at(disk, right, {:file, file_size - empty_size, file_id})
            |> List.insert_at(right + 1, {:empty, empty_size})
            |> List.replace_at(left, {:file, empty_size, file_id})
            |> defragment(left + 1, right)
        end
    end
  end

  def compact(disk) do
    compact(disk, Enum.reverse(disk))
  end

  defp compact(disk, reverse_disk) when length(reverse_disk) == 0 do
    disk
  end

  defp compact(disk, reverse_disk) do
    {blob, reverse_disk} = List.pop_at(reverse_disk, 0)

    case blob do
      {:empty, _} ->
        compact(disk, reverse_disk)

      {:file, file_size, file_id} ->
        case find_compact_indices(disk, file_id, file_size) do
          {_, nil, nil} ->
            compact(disk, reverse_disk)

          {file_index, empty_index, {:empty, empty_size}} ->
            diff = empty_size - file_size

            cond do
              diff == 0 ->
                List.replace_at(disk, empty_index, {:file, file_size, file_id})
                |> List.replace_at(file_index, {:empty, file_size})
                |> compact(reverse_disk)

              diff > 0 ->
                List.replace_at(disk, empty_index, {:file, file_size, file_id})
                |> List.replace_at(file_index, {:empty, file_size})
                |> List.insert_at(empty_index + 1, {:empty, diff})
                |> compact(reverse_disk)
            end
        end
    end
  end

  defp find_compact_indices(disk, file_id, file_size) do
    file_index =
      Enum.find_index(disk, fn search_blob ->
        case search_blob do
          {:file, _, id} when id == file_id -> true
          _ -> false
        end
      end)

    {fitting_empty, fitting_empty_index} =
      Enum.with_index(disk)
      |> Enum.find({nil, nil}, fn search_blob ->
        case search_blob do
          {{:empty, empty_size}, empty_index}
          when empty_size >= file_size and empty_index < file_index ->
            true

          _ ->
            false
        end
      end)

    {file_index, fitting_empty_index, fitting_empty}
  end

  def read_disk(string) do
    string
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index(fn elem, index ->
      case Integer.is_even(index) do
        true -> {:file, elem, div(index, 2)}
        false -> {:empty, elem}
      end
    end)
  end

  def visualize(disk) do
    for blob <- disk do
      case blob do
        {:file, size, id} -> String.duplicate(Integer.to_string(id), size)
        {:empty, size} -> String.duplicate(".", size)
      end
    end
    |> Enum.join()
  end

  def checksum(disk) do
    Enum.reduce(disk, {0, 0}, fn blob, {index, total} ->
      case blob do
        {:file, size, id} ->
          new_total =
            Enum.reduce(index..(index + size - 1), total, fn x, acc ->
              acc + x * id
            end)

          {index + size, new_total}

        {:empty, size} ->
          {index + size, total}
      end
    end)
    |> elem(1)
  end
end

disk = File.read!("9.in") |> DiskUtils.read_disk()
part_1 = disk |> DiskUtils.defragment() |> DiskUtils.checksum()
part_2 = disk |> DiskUtils.compact() |> DiskUtils.checksum()

IO.puts("Part 1: #{part_1}")
IO.puts("Part 2: #{part_2}")
