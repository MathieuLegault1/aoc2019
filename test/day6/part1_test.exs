defmodule AdventOfCode.Day6.Part1Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day6.Part1

  test "run/1 returns the correct output given the examples" do
    assert Part1.run("COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L") === 42
  end
end
