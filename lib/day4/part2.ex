defmodule AdventOfCode.Day4.Part2 do
  def run(input) do
    [lower_bound, higher_bound] =
      input
      |> String.split("-")

    String.to_integer(lower_bound)..String.to_integer(higher_bound)
    |> Enum.reduce([], fn number, acc ->
      if is_valid?(Integer.to_string(number)) do
        acc ++ [number]
      else
        acc
      end
    end)
    |> Enum.count()
  end

  defp is_valid?(number) do
    never_decrease?("0", String.graphemes(number)) && two_adjacent_digit?(number)
  end

  defp never_decrease?(_last_digit, []), do: true

  defp never_decrease?(last_digit, [current_digit | rest]) do
    if last_digit > current_digit do
      false
    else
      never_decrease?(current_digit, rest)
    end
  end

  defp two_adjacent_digit?(number) do
    number
    |> String.graphemes()
    |> Enum.group_by(fn item -> item end)
    |> Enum.any?(fn {_key, values} -> Enum.count(values) == 2 end)
  end
end
