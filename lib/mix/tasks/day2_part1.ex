defmodule Mix.Tasks.Day2Part1 do
  use Mix.Task

  alias AdventOfCode.Day2.Part1

  def run(_args) do
    "inputs/day2_part1.txt"
    |> File.read()
    |> case do
      {:ok, input} ->
        input
        |> Part1.run()
        |> IO.inspect(limit: :infinity)

      {:error, _error} ->
        IO.puts("The provided file path doesn't exist")
    end
  end
end
