defmodule AdventOfCode.Day1.Part1 do
  def run(input) do
    input
    |> String.split("\n")
    |> Enum.map(&calculate_fuel_requirement_for_mass/1)
    |> Enum.sum()
  end

  defp calculate_fuel_requirement_for_mass(module_mass) do
    module_mass
    |> String.to_integer()
    |> Kernel./(3)
    |> Kernel.floor()
    |> Kernel.-(2)
  end
end
