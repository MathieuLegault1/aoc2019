defmodule AdventOfCode.Day3.Part2 do
  @right_movement_key "R"
  @left_movement_key "L"
  @up_movement_key "U"
  @down_movement_key "D"

  def run(input) do
    [{_final_position_wire_2, _total_wire_1_steps, wire_1_positions}, {_final_position_wire_1, _total_wire_2_steps, wire_2_positions}] =
      input
      |> String.split("\n")
      |> Enum.map(&perform_steps/1)

    wire_1_positions
    |> find_total_distances(wire_2_positions)
    |> Enum.min()
  end

  defp perform_steps(steps) do
    steps
    |> String.split(",")
    |> Enum.reduce({{0, 0}, 0, Map.new()}, fn step, acc ->
      {direction, number_of_steps} = String.next_codepoint(step)
      perform_step(acc, direction, String.to_integer(number_of_steps))
    end)
  end

  defp perform_step(acc, @right_movement_key, number_of_step_to_perform) do
    fn_modify_position = fn {x, y} -> {x + 1, y} end
    do_perform_step(acc, number_of_step_to_perform, fn_modify_position)
  end

  defp perform_step(acc, @left_movement_key, number_of_step_to_perform) do
    fn_modify_position = fn {x, y} -> {x - 1, y} end
    do_perform_step(acc, number_of_step_to_perform, fn_modify_position)
  end

  defp perform_step(acc, @up_movement_key, number_of_step_to_perform) do
    fn_modify_position = fn {x, y} -> {x, y + 1} end
    do_perform_step(acc, number_of_step_to_perform, fn_modify_position)
  end

  defp perform_step(acc, @down_movement_key, number_of_step_to_perform) do
    fn_modify_position = fn {x, y} -> {x, y - 1} end
    do_perform_step(acc, number_of_step_to_perform, fn_modify_position)
  end

  defp do_perform_step(acc, number_of_step_to_perform, fn_modify_position) do
    Enum.reduce(1..number_of_step_to_perform, acc, fn _current_step_number, {current_position, current_wire_step, map} ->
      new_position = fn_modify_position.(current_position)
      new_current_wire_step = current_wire_step + 1

      {new_position, new_current_wire_step, Map.put(map, new_position, new_current_wire_step)}
    end)
  end

  defp find_total_distances(map1, map2) do
    map1_intersection = Map.take(map1, Map.keys(map2))

    Enum.map(map1_intersection, fn {key, value} ->
      value + Map.get(map2, key)
    end)
  end
end
