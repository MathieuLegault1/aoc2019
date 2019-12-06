defmodule AdventOfCode.Day5.Part2 do
  @addition_opcode 1
  @multiplication_opcode 2
  @input_opcode 3
  @output_opcode 4
  @halt_opcode 99

  def run(input) do
    intcode_program =
      input
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    parse_opcodes(intcode_program, 0) |> Enum.at(0)
  end

  defp parse_opcodes(intcode_program, instruction_pointer_index) do
    {opcode_number, number_of_parameters} = current_opcode(intcode_program)

    intcode_program
    |> Enum.slice(instruction_pointer_index, number_of_parameters)
    |> parse_opcode_and_update_program(opcode_number)
    |> case do
      {:cont, updated_intcode_program} ->
        parse_opcodes(updated_intcode_program, instruction_pointer_index + number_of_parameters)

      {:halt, updated_intcode_program} ->
        updated_intcode_program
    end
  end

  defp parse_opcode_and_update_program([_, value_1, value_2, override_index] = intcode_program, @addition_opcode) do
    value_1 = value_by_parameter_mode(intcode_program, value_1, 3)
    value_2 = value_by_parameter_mode(intcode_program, value_2, 4)

    intcode_program = List.replace_at(intcode_program, override_index, value_1 + value_2)

    {:cont, intcode_program}
  end

  defp parse_opcode_and_update_program([_, value_1, value_2, override_index] = intcode_program, @multiplication_opcode) do
    value_1 = value_by_parameter_mode(intcode_program, value_1, 3)
    value_2 = value_by_parameter_mode(intcode_program, value_2, 4)

    intcode_program = List.replace_at(intcode_program, override_index, value_1 + value_2)

    {:cont, intcode_program}
  end

  defp parse_opcode_and_update_program([_, override_index] = intcode_program, @input_opcode) do
    intcode_program = List.replace_at(intcode_program, override_index, 1)

    {:cont, intcode_program}
  end

  defp parse_opcode_and_update_program([_, value_1] = intcode_program, @output_opcode) do
    value_1 = value_by_parameter_mode(intcode_program, value_1, 3)

    IO.puts(value_1)

    {:cont, intcode_program}
  end

  defp parse_opcode_and_update_program(intcode_program, 99) do
    {:halt, intcode_program}
  end

  defp current_opcode([opcode | _rest]) do
    opcode
    |> Integer.digits()
    |> Enum.take(-2)
    |> Integer.undigits()
    |> case do
      @addition_opcode -> {@addition_opcode, 4}
      @multiplication_opcode -> {@multiplication_opcode, 4}
      @input_opcode -> {@input_opcode, 2}
      @output_opcode -> {@output_opcode, 2}
      @halt_opcode -> {@halt_opcode, 1}
    end
  end

  defp value_by_parameter_mode([opcode | _rest] = intcode_program, value, parameter_index) do
    opcode
    |> Integer.digits()
    |> Enum.reverse()
    |> Enum.at(parameter_index)
    |> case do
      nil ->
        Enum.at(intcode_program, parameter_index) |> IO.inspect()

      0 ->
        Enum.at(intcode_program, parameter_index) |> IO.inspect()

      1 ->
        value
    end
  end
end
