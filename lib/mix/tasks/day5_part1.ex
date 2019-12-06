defmodule Mix.Tasks.Day5Part1 do
  use Mix.Task

  alias AdventOfCode.Day5.Part1

  def run(_args) do
    "inputs/day5_part1.txt"
    |> File.read()
    |> case do
      {:ok, input} ->
        input
        |> Part1.run()

      {:error, _error} ->
        IO.puts("The provided file path doesn't exist")
    end
  end
end
