defmodule AdventOfCode.Day6.Part1 do
  def run(input) do
    orbiter_map =
      input
      |> String.split("\n")
      |> Enum.reduce(Map.new(), fn item, map ->
        [orbitee, orbiter] = String.split(item, ")")

        Map.put(map, orbiter, orbitee)
      end)

    orbiter_map
    |> Enum.map(fn {_orbiter, orbittee} ->
      find_total_orbits(0, orbittee, orbiter_map)
    end)
    |> Enum.sum()
  end

  defp find_total_orbits(total, nil, _map), do: total

  defp find_total_orbits(total, current_object, map) do
    1 + find_total_orbits(total, Map.get(map, current_object), map)
  end
end
