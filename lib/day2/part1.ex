defmodule AdventOfCode.Day2.Part1 do
  def run(input) do
    #    Enum.chunk_every([1, 2, 3, 4, 5, 6], 2)
    #    [[1, 2], [3, 4], [5, 6]]

    values =
      input
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    number_of_opcode =
      input
      |> String.length()
      |> Kernel.-(1)
      |> div(4)

    Enum.reduce_while(0..number_of_opcode, values, fn opcode_index, values ->
      values
      |> Enum.at(opcode_index * 4)
      |> case do
        99 ->
          {:halt, values}

        _ = opcode ->
          value_1 = get_value_at_index(values, opcode_index * 4 + 1)
          value_2 = get_value_at_index(values, opcode_index * 4 + 2)
          overwrite_index = Enum.at(values, opcode_index * 4 + 3)
          {:cont, apply_opcode_changes(values, opcode, value_1, value_2, overwrite_index)}
      end
    end)
  end

  defp get_value_at_index(values, index) do
    index = Enum.at(values, index)
    Enum.at(values, index)
  end

  defp apply_opcode_changes(values, 1, value_1, value_2, overwrite_index) do
    List.update_at(values, overwrite_index, fn _ -> value_1 + value_2 end)
  end

  defp apply_opcode_changes(values, 2, value_1, value_2, overwrite_index) do
    List.update_at(values, overwrite_index, fn _ -> value_1 * value_2 end)
  end
end
