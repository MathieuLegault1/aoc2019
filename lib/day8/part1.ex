defmodule AdventOfCode.Day8.Part1 do
  def run(input) do
    {_number_of_zero, layer} =
      input
      |> String.graphemes()
      |> Enum.chunk_every(150)
      |> Enum.map(fn layer ->
        number_of_zero = number_of_digit(layer, "0")
        {number_of_zero, layer}
      end)
      |> Enum.min_by(fn {number_of_zero, _layer} -> number_of_zero end)

    number_of_digit(layer, "1") * number_of_digit(layer, "2")
  end

  defp number_of_digit(layer, digit) do
    Enum.count(layer, &(&1 == digit))
  end
end
