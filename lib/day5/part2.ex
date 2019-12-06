defmodule AdventOfCode.Day5.Part2 do
  @addition_opcode 1
  @multiplication_opcode 2
  @input_opcode 3
  @output_opcode 4
  @jump_if_true_opcode 5
  @jump_if_false_opcode 6
  @less_than_opcode 7
  @equals_opcode 8
  @halt_opcode 99

  def run(input) do
    intcode_program =
      input
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    parse_opcodes(intcode_program, 0)
  end

  defp parse_opcodes(intcode_program, instruction_pointer) do
    {opcode_number, number_of_parameters} =
      intcode_program
      |> Enum.at(instruction_pointer)
      |> current_opcode()

    intcode_program
    |> Enum.slice(instruction_pointer, number_of_parameters)
    |> parse_opcode_and_update_program(intcode_program, opcode_number, instruction_pointer)
    |> case do
      {:cont, {updated_intcode_program, instruction_pointer}} ->
        parse_opcodes(updated_intcode_program, instruction_pointer)

      {:halt, updated_intcode_program} ->
        updated_intcode_program
    end
  end

  defp parse_opcode_and_update_program([current_opcode, value_1, value_2, override_index], intcode_program, @addition_opcode, instruction_pointer) do
    value_1 = value_by_parameter_mode(current_opcode, intcode_program, value_1, 2)
    value_2 = value_by_parameter_mode(current_opcode, intcode_program, value_2, 3)

    intcode_program = List.replace_at(intcode_program, override_index, value_1 + value_2)

    {:cont, {intcode_program, instruction_pointer + 4}}
  end

  defp parse_opcode_and_update_program([current_opcode, value_1, value_2, override_index], intcode_program, @multiplication_opcode, instruction_pointer) do
    value_1 = value_by_parameter_mode(current_opcode, intcode_program, value_1, 2)
    value_2 = value_by_parameter_mode(current_opcode, intcode_program, value_2, 3)

    intcode_program = List.replace_at(intcode_program, override_index, value_1 * value_2)

    {:cont, {intcode_program, instruction_pointer + 4}}
  end

  defp parse_opcode_and_update_program([_current_opcode, override_index], intcode_program, @input_opcode, instruction_pointer) do
    intcode_program = List.replace_at(intcode_program, override_index, 5)

    {:cont, {intcode_program, instruction_pointer + 2}}
  end

  defp parse_opcode_and_update_program([current_opcode, value_1], intcode_program, @output_opcode, instruction_pointer) do
    value_1 = value_by_parameter_mode(current_opcode, intcode_program, value_1, 2)

    IO.puts(value_1)

    {:cont, {intcode_program, instruction_pointer + 2}}
  end

  defp parse_opcode_and_update_program([current_opcode, value_1, value_2], intcode_program, @jump_if_true_opcode, instruction_pointer) do
    value_1 = value_by_parameter_mode(current_opcode, intcode_program, value_1, 2)
    value_2 = value_by_parameter_mode(current_opcode, intcode_program, value_2, 3)

    if value_1 != 0 do
      {:cont, {intcode_program, value_2}}
    else
      {:cont, {intcode_program, instruction_pointer + 3}}
    end
  end

  defp parse_opcode_and_update_program([current_opcode, value_1, value_2], intcode_program, @jump_if_false_opcode, instruction_pointer) do
    value_1 = value_by_parameter_mode(current_opcode, intcode_program, value_1, 2)
    value_2 = value_by_parameter_mode(current_opcode, intcode_program, value_2, 3)

    if value_1 === 0 do
      {:cont, {intcode_program, value_2}}
    else
      {:cont, {intcode_program, instruction_pointer + 3}}
    end
  end

  defp parse_opcode_and_update_program([current_opcode, value_1, value_2, override_index], intcode_program, @less_than_opcode, instruction_pointer) do
    value_1 = value_by_parameter_mode(current_opcode, intcode_program, value_1, 2)
    value_2 = value_by_parameter_mode(current_opcode, intcode_program, value_2, 3)

    intcode_program =
      if value_1 < value_2 do
        List.replace_at(intcode_program, override_index, 1)
      else
        List.replace_at(intcode_program, override_index, 0)
      end

    {:cont, {intcode_program, instruction_pointer + 4}}
  end

  defp parse_opcode_and_update_program([current_opcode, value_1, value_2, override_index], intcode_program, @equals_opcode, instruction_pointer) do
    value_1 = value_by_parameter_mode(current_opcode, intcode_program, value_1, 2)
    value_2 = value_by_parameter_mode(current_opcode, intcode_program, value_2, 3)

    intcode_program =
      if value_1 === value_2 do
        List.replace_at(intcode_program, override_index, 1)
      else
        List.replace_at(intcode_program, override_index, 0)
      end

    {:cont, {intcode_program, instruction_pointer + 4}}
  end

  defp parse_opcode_and_update_program(_, intcode_program, @halt_opcode, _instruction_pointer) do
    {:halt, intcode_program}
  end

  defp current_opcode(opcode) do
    opcode
    |> Integer.digits()
    |> Enum.take(-2)
    |> Integer.undigits()
    |> case do
      @addition_opcode -> {@addition_opcode, 4}
      @multiplication_opcode -> {@multiplication_opcode, 4}
      @input_opcode -> {@input_opcode, 2}
      @output_opcode -> {@output_opcode, 2}
      @jump_if_true_opcode -> {@jump_if_true_opcode, 3}
      @jump_if_false_opcode -> {@jump_if_false_opcode, 3}
      @less_than_opcode -> {@less_than_opcode, 4}
      @equals_opcode -> {@equals_opcode, 4}
      @halt_opcode -> {@halt_opcode, 1}
    end
  end

  defp value_by_parameter_mode(opcode, intcode_program, value, parameter_index) do
    opcode
    |> Integer.digits()
    |> Enum.reverse()
    |> Enum.at(parameter_index)
    |> case do
      nil ->
        Enum.at(intcode_program, value)

      0 ->
        Enum.at(intcode_program, value)

      1 ->
        value
    end
  end
end
