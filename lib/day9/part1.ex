defmodule AdventOfCode.Day9.Part1 do
  @addition_opcode 1
  @multiplication_opcode 2
  @input_opcode 3
  @output_opcode 4
  @jump_if_true_opcode 5
  @jump_if_false_opcode 6
  @less_than_opcode 7
  @equals_opcode 8
  @adjust_relative_base_opcode 9
  @halt_opcode 99

  def run(input) do
    intcode_program =
      input
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    {:ok, outputs} = execute_program(intcode_program, 0, [1], [], %{relative_base: 0})
    outputs
  end

  defp execute_program(intcode_program, instruction_pointer, inputs, outputs, options) do
    {current_opcode, parameter_modes} =
      intcode_program
      |> Enum.at(instruction_pointer)
      |> current_opcode()

    case current_opcode do
      @addition_opcode ->
        add(intcode_program, parameter_modes, instruction_pointer, options)

      @multiplication_opcode ->
        multiply(intcode_program, parameter_modes, instruction_pointer, options)

      @input_opcode ->
        input(intcode_program, parameter_modes, instruction_pointer, inputs, outputs, options)

      @output_opcode ->
        output(intcode_program, parameter_modes, instruction_pointer, inputs, outputs, options)

      @jump_if_true_opcode ->
        jump_if_true(intcode_program, parameter_modes, instruction_pointer, options)

      @jump_if_false_opcode ->
        jump_if_false(intcode_program, parameter_modes, instruction_pointer, options)

      @less_than_opcode ->
        less_than(intcode_program, parameter_modes, instruction_pointer, options)

      @equals_opcode ->
        equals(intcode_program, parameter_modes, instruction_pointer, options)

      @adjust_relative_base_opcode ->
        adjust_relative_base(intcode_program, parameter_modes, instruction_pointer, options)

      @halt_opcode ->
        {:halt, outputs}
    end
    |> case do
      {:cont, {updated_intcode_program, instruction_pointer}} ->
        execute_program(updated_intcode_program, instruction_pointer, inputs, outputs, options)

      {:cont_side_effect, {updated_intcode_program, instruction_pointer, inputs, outputs}} ->
        execute_program(updated_intcode_program, instruction_pointer, inputs, outputs, options)

      {:cont_modify_options, {updated_intcode_program, instruction_pointer, options}} ->
        execute_program(updated_intcode_program, instruction_pointer, inputs, outputs, options)

      {:halt, outputs} ->
        {:ok, outputs}
    end
  end

  defp add(intcode_program, parameter_modes, instruction_pointer, options) do
    [value_1, value_2, override_index] = Enum.slice(intcode_program, instruction_pointer + 1, 3)
    value_1 = value_by_mode(intcode_program, parameter_modes, value_1, 0, options)
    value_2 = value_by_mode(intcode_program, parameter_modes, value_2, 1, options)
    override_index = write_to(intcode_program, parameter_modes, override_index, 2, options)

    intcode_program = insert_or_update_at(intcode_program, override_index, value_1 + value_2)

    {:cont, {intcode_program, instruction_pointer + 4}}
  end

  defp multiply(intcode_program, parameter_modes, instruction_pointer, options) do
    [value_1, value_2, override_index] = Enum.slice(intcode_program, instruction_pointer + 1, 3)
    value_1 = value_by_mode(intcode_program, parameter_modes, value_1, 0, options)
    value_2 = value_by_mode(intcode_program, parameter_modes, value_2, 1, options)
    override_index = write_to(intcode_program, parameter_modes, override_index, 2, options)

    intcode_program = insert_or_update_at(intcode_program, override_index, value_1 * value_2)

    {:cont, {intcode_program, instruction_pointer + 4}}
  end

  defp input(intcode_program, parameter_modes, instruction_pointer, [current_input | rest], outputs, options) do
    [override_index] = Enum.slice(intcode_program, instruction_pointer + 1, 1)
    override_index = write_to(intcode_program, parameter_modes, override_index, 0, options)

    intcode_program = insert_or_update_at(intcode_program, override_index, current_input)

    {:cont_side_effect, {intcode_program, instruction_pointer + 2, rest, outputs}}
  end

  defp input(intcode_program, _parameter_modes, instruction_pointer, _inputs, outputs, _options) do
    {:halt, {intcode_program, instruction_pointer, outputs}}
  end

  defp output(intcode_program, parameter_modes, instruction_pointer, inputs, outputs, options) do
    [value] = Enum.slice(intcode_program, instruction_pointer + 1, 1)
    value = value_by_mode(intcode_program, parameter_modes, value, 0, options)

    outputs = outputs ++ [value]

    {:cont_side_effect, {intcode_program, instruction_pointer + 2, inputs, outputs}}
  end

  defp jump_if_true(intcode_program, parameter_modes, instruction_pointer, options) do
    [value_1, value_2] = Enum.slice(intcode_program, instruction_pointer + 1, 2)
    value_1 = value_by_mode(intcode_program, parameter_modes, value_1, 0, options)
    value_2 = value_by_mode(intcode_program, parameter_modes, value_2, 1, options)

    if value_1 != 0 do
      {:cont, {intcode_program, value_2}}
    else
      {:cont, {intcode_program, instruction_pointer + 3}}
    end
  end

  defp jump_if_false(intcode_program, parameter_modes, instruction_pointer, options) do
    [value_1, value_2] = Enum.slice(intcode_program, instruction_pointer + 1, 2)
    value_1 = value_by_mode(intcode_program, parameter_modes, value_1, 0, options)
    value_2 = value_by_mode(intcode_program, parameter_modes, value_2, 1, options)

    if value_1 === 0 do
      {:cont, {intcode_program, value_2}}
    else
      {:cont, {intcode_program, instruction_pointer + 3}}
    end
  end

  defp less_than(intcode_program, parameter_modes, instruction_pointer, options) do
    [value_1, value_2, override_index] = Enum.slice(intcode_program, instruction_pointer + 1, 3)
    value_1 = value_by_mode(intcode_program, parameter_modes, value_1, 0, options)
    value_2 = value_by_mode(intcode_program, parameter_modes, value_2, 1, options)
    override_index = write_to(intcode_program, parameter_modes, override_index, 2, options)

    intcode_program =
      if value_1 < value_2 do
        insert_or_update_at(intcode_program, override_index, 1)
      else
        insert_or_update_at(intcode_program, override_index, 0)
      end

    {:cont, {intcode_program, instruction_pointer + 4}}
  end

  defp equals(intcode_program, parameter_modes, instruction_pointer, options) do
    [value_1, value_2, override_index] = Enum.slice(intcode_program, instruction_pointer + 1, 3)
    value_1 = value_by_mode(intcode_program, parameter_modes, value_1, 0, options)
    value_2 = value_by_mode(intcode_program, parameter_modes, value_2, 1, options)
    override_index = write_to(intcode_program, parameter_modes, override_index, 2, options)

    intcode_program =
      if value_1 === value_2 do
        insert_or_update_at(intcode_program, override_index, 1)
      else
        insert_or_update_at(intcode_program, override_index, 0)
      end

    {:cont, {intcode_program, instruction_pointer + 4}}
  end

  defp adjust_relative_base(intcode_program, parameter_modes, instruction_pointer, options) do
    [value_1] = Enum.slice(intcode_program, instruction_pointer + 1, 1)
    value_1 = value_by_mode(intcode_program, parameter_modes, value_1, 0, options)
    options = %{options | relative_base: options.relative_base + value_1}

    {:cont_modify_options, {intcode_program, instruction_pointer + 2, options}}
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

  defp value_by_mode(intcode_program, modes, value, parameter_index, options) do
    modes
    |> Enum.at(parameter_index)
    |> case do
      nil ->
        Enum.at(intcode_program, value, 0)

      0 ->
        Enum.at(intcode_program, value, 0)

      1 ->
        value

      2 ->
        Enum.at(intcode_program, value + options.relative_base, 0)
    end
  end

  defp write_to(_intcode_program, modes, value, parameter_index, options) do
    modes
    |> Enum.at(parameter_index)
    |> case do
      nil ->
        value

      0 ->
        value

      2 ->
        value + options.relative_base
    end
  end

  defp insert_or_update_at(list, index, value) do
    if length(list) > index do
      List.replace_at(list, index, value)
    else
      list = list ++ List.duplicate(0, index - length(list) + 1)
      insert_or_update_at(list, index, value)
    end
  end
end
