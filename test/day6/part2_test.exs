defmodule AdventOfCode.Day6.Part2Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day6.Part2

  @tag :day6
  test "run/1 returns the correct output given the examples" do
    assert Part2.run("COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L\nK)YOU\nI)SAN") === 4
  end
end
