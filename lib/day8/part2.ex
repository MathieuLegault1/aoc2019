defmodule AdventOfCode.Day8.Part2 do
  def run(input) do
    initial_transparent_layer = List.duplicate("2", 150)

    input
    |> String.graphemes()
    |> Enum.chunk_every(150)
    |> Enum.reduce(initial_transparent_layer, fn layer, result_picture ->
      merge_layers(result_picture, layer)
    end)
    |> print_password()
  end

  defp merge_layers(front_layer, back_layer) do
    front_layer
    |> Enum.with_index()
    |> Enum.map(fn {front_color, index} ->
      back_color = Enum.at(back_layer, index)

      if front_color == "2" do
        back_color
      else
        front_color
      end
    end)
  end

  defp print_password(picture) do
    for y <- 0..5 do
      for x <- 0..24 do
        current_index = y * 25 + x

        picture
        |> Enum.at(current_index)
        |> case do
          "0" ->
            IO.write(" ")

          "1" ->
            IO.write("b")
        end

        if x == 24 do
          IO.puts("")
        end
      end
    end
  end
end
