defmodule AdventOfCode.Day2.Part2 do
  @addition_opcode 1
  @multiplication_opcode 2

  def run(input, expected_value) do
    initial_intcode_program =
      input
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    possible_values = for verb <- 0..99, noun <- 0..99, do: {verb, noun}

    {verb, noun, _value} =
      Enum.map(possible_values, fn {verb, noun} ->
        intcode_program =
          initial_intcode_program
          |> List.replace_at(1, noun)
          |> List.replace_at(2, verb)

        {verb, noun, parse_opcodes(intcode_program, 0) |> List.first()}
      end)
      |> Enum.find(fn {_verb, _noun, value} ->
        value === expected_value
      end)

    100 * noun + verb
  end

  defp parse_opcodes(intcode_program, instruction_pointer_index) do
    intcode_program
    |> Enum.slice(instruction_pointer_index, 4)
    |> parse_opcode_and_update_program(intcode_program)
    |> case do
      {:cont, updated_intcode_program} ->
        parse_opcodes(updated_intcode_program, instruction_pointer_index + 4)

      {:halt, updated_memory} ->
        updated_memory
    end
  end

  defp parse_opcode_and_update_program([@addition_opcode, value_1_index, value_2_index, override_index], intcode_program) do
    value_1 = Enum.at(intcode_program, value_1_index)
    value_2 = Enum.at(intcode_program, value_2_index)

    intcode_program = List.replace_at(intcode_program, override_index, value_1 + value_2)

    {:cont, intcode_program}
  end

  defp parse_opcode_and_update_program([@multiplication_opcode, value_1_index, value_2_index, override_index], intcode_program) do
    value_1 = Enum.at(intcode_program, value_1_index)
    value_2 = Enum.at(intcode_program, value_2_index)

    intcode_program = List.replace_at(intcode_program, override_index, value_1 * value_2)

    {:cont, intcode_program}
  end

  defp parse_opcode_and_update_program([99 | _tail], intcode_program) do
    {:halt, intcode_program}
  end
end
