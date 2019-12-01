defmodule AdventOfCode.Day1.Part2Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day1.Part2

  test "run/1 returns the correct output given the examples" do
    assert Part2.run("12") === 2
    assert Part2.run("14") === 2
    assert Part2.run("1969") === 966
    assert Part2.run("100756") === 50_346
  end
end
