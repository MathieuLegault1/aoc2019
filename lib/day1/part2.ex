defmodule AdventOfCode.Day1.Part2 do
  def run(input) do
    input
    |> String.split("\n")
    |> Enum.map(&calculate_fuel_requirement_for_mass/1)
    |> Enum.sum()
  end

  defp calculate_fuel_requirement_for_mass(mass) when is_binary(mass) do
    mass
    |> String.to_integer()
    |> calculate_fuel_requirement_for_mass()
  end

  defp calculate_fuel_requirement_for_mass(mass) do
    fuel_requirement =
      mass
      |> Kernel./(3)
      |> Kernel.floor()
      |> Kernel.-(2)

    if fuel_requirement >= 6 do
      fuel_requirement + calculate_fuel_requirement_for_mass(fuel_requirement)
    else
      fuel_requirement
    end
  end
end
