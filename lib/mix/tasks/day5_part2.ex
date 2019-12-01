defmodule Mix.Tasks.Day5Part2 do
  use Mix.Task

  alias AdventOfCode.Day5.Part2

  def run(_args) do
    "inputs/day5_part2.txt"
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
