defmodule Mix.Tasks.Day9Part1 do
  use Mix.Task

  alias AdventOfCode.Day9.Part1

  def run(_args) do
    "inputs/day9_part1.txt"
    |> File.read()
    |> case do
      {:ok, input} ->
        input
        |> Part1.run()
        |> IO.inspect()

      {:error, _error} ->
        IO.puts("The provided file path doesn't exist")
    end
  end
end
