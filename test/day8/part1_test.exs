defmodule AdventOfCode.Day8.Part1Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day8.Part1

  test "run/1 returns the correct output given the examples" do
    assert Part1.run("123456789012") === 2
  end
end
