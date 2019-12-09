defmodule AdventOfCode.Day7.Part1 do
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

    possible_values = permute([0, 1, 2, 3, 4])

    Enum.map(possible_values, fn [thruster_1_setting, thruster_2_setting, thruster_3_setting, thruster_4_setting, thruster_5_setting] ->
      [thruster_1_output] = execute_program(intcode_program, 0, [thruster_1_setting, 0], [])
      [thruster_2_output] = execute_program(intcode_program, 0, [thruster_2_setting, thruster_1_output], [])
      [thruster_3_output] = execute_program(intcode_program, 0, [thruster_3_setting, thruster_2_output], [])
      [thruster_4_output] = execute_program(intcode_program, 0, [thruster_4_setting, thruster_3_output], [])
      [thruster_5_output] = execute_program(intcode_program, 0, [thruster_5_setting, thruster_4_output], [])
      {thruster_5_output, thruster_1_setting, thruster_2_setting, thruster_3_setting, thruster_4_setting, thruster_5_setting}
    end)
    |> Enum.max_by(fn thruster_5_output ->
      thruster_5_output
      |> elem(0)
    end)
    |> elem(0)
  end

  defp execute_program(intcode_program, instruction_pointer, inputs, outputs) do
    {current_opcode, parameter_modes} =
      intcode_program
      |> Enum.at(instruction_pointer)
      |> current_opcode()

    case current_opcode do
      @addition_opcode ->
        add(intcode_program, parameter_modes, instruction_pointer)

      @multiplication_opcode ->
        multiply(intcode_program, parameter_modes, instruction_pointer)

      @input_opcode ->
        input(intcode_program, instruction_pointer, inputs, outputs)

      @output_opcode ->
        output(intcode_program, parameter_modes, instruction_pointer, inputs, outputs)

      @jump_if_true_opcode ->
        jump_if_true(intcode_program, parameter_modes, instruction_pointer)

      @jump_if_false_opcode ->
        jump_if_false(intcode_program, parameter_modes, instruction_pointer)

      @less_than_opcode ->
        less_than(intcode_program, parameter_modes, instruction_pointer)

      @equals_opcode ->
        equals(intcode_program, parameter_modes, instruction_pointer)

      @halt_opcode ->
        {:halt, outputs}
    end
    |> case do
      {:cont, {updated_intcode_program, instruction_pointer}} ->
        execute_program(updated_intcode_program, instruction_pointer, inputs, outputs)

      {:cont_side_effect, {updated_intcode_program, instruction_pointer, inputs, outputs}} ->
        execute_program(updated_intcode_program, instruction_pointer, inputs, outputs)

      {:halt, outputs} ->
        outputs
    end
  end

  defp add(intcode_program, parameter_modes, instruction_pointer) do
    [value_1, value_2, override_index] = Enum.slice(intcode_program, instruction_pointer + 1, 3)
    value_1 = value_by_mode(intcode_program, parameter_modes, value_1, 0)
    value_2 = value_by_mode(intcode_program, parameter_modes, value_2, 1)

    intcode_program = List.replace_at(intcode_program, override_index, value_1 + value_2)

    {:cont, {intcode_program, instruction_pointer + 4}}
  end

  defp multiply(intcode_program, parameter_modes, instruction_pointer) do
    [value_1, value_2, override_index] = Enum.slice(intcode_program, instruction_pointer + 1, 3)
    value_1 = value_by_mode(intcode_program, parameter_modes, value_1, 0)
    value_2 = value_by_mode(intcode_program, parameter_modes, value_2, 1)

    intcode_program = List.replace_at(intcode_program, override_index, value_1 * value_2)

    {:cont, {intcode_program, instruction_pointer + 4}}
  end

  defp input(intcode_program, instruction_pointer, [current_input | rest], outputs) do
    [override_index] = Enum.slice(intcode_program, instruction_pointer + 1, 1)

    intcode_program = List.replace_at(intcode_program, override_index, current_input)

    {:cont_side_effect, {intcode_program, instruction_pointer + 2, rest, outputs}}
  end

  defp output(intcode_program, parameter_modes, instruction_pointer, inputs, outputs) do
    [value] = Enum.slice(intcode_program, instruction_pointer + 1, 1)
    value = value_by_mode(intcode_program, parameter_modes, value, 0)

    outputs = outputs ++ [value]

    {:cont_side_effect, {intcode_program, instruction_pointer + 2, inputs, outputs}}
  end

  defp jump_if_true(intcode_program, parameter_modes, instruction_pointer) do
    [value_1, value_2] = Enum.slice(intcode_program, instruction_pointer + 1, 2)
    value_1 = value_by_mode(intcode_program, parameter_modes, value_1, 0)
    value_2 = value_by_mode(intcode_program, parameter_modes, value_2, 1)

    if value_1 != 0 do
      {:cont, {intcode_program, value_2}}
    else
      {:cont, {intcode_program, instruction_pointer + 3}}
    end
  end

  defp jump_if_false(intcode_program, parameter_modes, instruction_pointer) do
    [value_1, value_2] = Enum.slice(intcode_program, instruction_pointer + 1, 2)
    value_1 = value_by_mode(intcode_program, parameter_modes, value_1, 0)
    value_2 = value_by_mode(intcode_program, parameter_modes, value_2, 1)

    if value_1 === 0 do
      {:cont, {intcode_program, value_2}}
    else
      {:cont, {intcode_program, instruction_pointer + 3}}
    end
  end

  defp less_than(intcode_program, parameter_modes, instruction_pointer) do
    [value_1, value_2, override_index] = Enum.slice(intcode_program, instruction_pointer + 1, 3)
    value_1 = value_by_mode(intcode_program, parameter_modes, value_1, 0)
    value_2 = value_by_mode(intcode_program, parameter_modes, value_2, 1)

    intcode_program =
      if value_1 < value_2 do
        List.replace_at(intcode_program, override_index, 1)
      else
        List.replace_at(intcode_program, override_index, 0)
      end

    {:cont, {intcode_program, instruction_pointer + 4}}
  end

  defp equals(intcode_program, parameter_modes, instruction_pointer) do
    [value_1, value_2, override_index] = Enum.slice(intcode_program, instruction_pointer + 1, 3)
    value_1 = value_by_mode(intcode_program, parameter_modes, value_1, 0)
    value_2 = value_by_mode(intcode_program, parameter_modes, value_2, 1)

    intcode_program =
      if value_1 === value_2 do
        List.replace_at(intcode_program, override_index, 1)
      else
        List.replace_at(intcode_program, override_index, 0)
      end

    {:cont, {intcode_program, instruction_pointer + 4}}
  end

  defp current_opcode(opcode) do
    {current_opcode_reversed, modes} =
      opcode
      |> Integer.digits()
      |> Enum.reverse()
      |> Enum.split(2)

    current_opcode =
      current_opcode_reversed
      |> Enum.reverse()
      |> Integer.undigits()

    {current_opcode, modes}
  end

  defp value_by_mode(intcode_program, modes, value, parameter_index) do
    modes
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

  def permute([]), do: [[]]

  def permute(list) do
    for x <- list, y <- permute(list -- [x]), do: [x | y]
  end
end
