defmodule AdventOfCode.Day6.Part2 do
  def run(input) do
    orbiter_map =
      input
      |> String.split("\n")
      |> Enum.reduce(Map.new(), fn item, map ->
        [orbitee, orbiter] = String.split(item, ")")

        Map.put(map, orbiter, orbitee)
      end)

    you_path = find_path(MapSet.new(), Map.get(orbiter_map, "YOU"), orbiter_map)
    san_path = find_path(MapSet.new(), Map.get(orbiter_map, "SAN"), orbiter_map)

    only_you_path = MapSet.difference(you_path, san_path)
    only_san_path = MapSet.difference(san_path, you_path)

    MapSet.size(only_you_path) + MapSet.size(only_san_path)
  end

  defp find_path(map_set, orbitee, map) do
    map_set = MapSet.put(map_set, orbitee)

    map
    |> Map.get(orbitee)
    |> case do
      nil ->
        map_set

      next_orbitee ->
        find_path(map_set, next_orbitee, map)
    end
  end
end
