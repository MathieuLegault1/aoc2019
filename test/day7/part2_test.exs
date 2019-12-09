defmodule AdventOfCode.Day7.Part2Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day7.Part2

  @tag :day7
  test "run/1 returns the correct output given the examples" do
    assert Part2.run("3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5") === 139_629_729

    assert Part2.run(
             "3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10"
           ) === 18216
  end
end
