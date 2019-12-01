defmodule Mix.Tasks.Day1Part2 do
  use Mix.Task

  alias AdventOfCode.Day1.Part2

  def run(_args) do
    "inputs/day1_part2.txt"
    |> File.read()
    |> case do
      {:ok, input} ->
        input
        |> Part2.run()
        |> IO.puts()

      {:error, _error} ->
        IO.puts("The provided file path doesn't exist")
    end
  end
end
