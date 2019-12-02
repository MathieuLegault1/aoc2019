defmodule AdventOfCode.Day2.Part1Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day2.Part1

  test "run/1 returns the correct output given the examples" do
    assert Part1.run("1,0,0,0,99") === [2, 0, 0, 0, 99]
    assert Part1.run("2,3,0,3,99") === [2, 3, 0, 6, 99]
    assert Part1.run("2,4,4,5,99,0") === [2, 4, 4, 5, 99, 9801]
    assert Part1.run("1,1,1,4,99,5,6,0,99") === [30, 1, 1, 4, 2, 5, 6, 0, 99]
  end
end
