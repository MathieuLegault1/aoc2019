defmodule AdventOfCode.Day1.Part1Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day1.Part1

  test "run/1 returns the correct output given the examples" do
    assert Part1.run("12") === 2
    assert Part1.run("14") === 2
    assert Part1.run("1969") === 654
    assert Part1.run("100756") === 33_583
  end
end
