defmodule Mix.Tasks.Day8Part2 do
  use Mix.Task

  alias AdventOfCode.Day8.Part2

  def run(_args) do
    "inputs/day8_part2.txt"
    |> File.read()
    |> case do
      {:ok, input} ->
        input
        |> Part2.run()

      {:error, _error} ->
        IO.puts("The provided file path doesn't exist")
    end
  end
end
