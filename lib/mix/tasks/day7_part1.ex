defmodule Mix.Tasks.Day7Part1 do
  use Mix.Task

  alias AdventOfCode.Day7.Part1

  def run(_args) do
    "inputs/day7_part1.txt"
    |> File.read()
    |> case do
      {:ok, input} ->
        input
        |> Part1.run()
        |> IO.puts()

      {:error, _error} ->
        IO.puts("The provided file path doesn't exist")
    end
  end
end
