defmodule Mix.Tasks.Day4Part1 do
  use Mix.Task

  alias AdventOfCode.Day4.Part1

  def run(_args) do
    "inputs/day4_part1.txt"
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
