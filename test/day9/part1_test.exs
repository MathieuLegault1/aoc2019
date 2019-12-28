defmodule AdventOfCode.Day9.Part1Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day9.Part1

  @tag :day9
  test "run/1 returns the correct output given the examples" do
    assert Part1.run("109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99") === [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99]
    assert Part1.run("1102,34915192,34915192,7,4,7,99,0") === [1_219_070_632_396_864]
    assert Part1.run("104,1125899906842624,99") === [1_125_899_906_842_624]
  end
end
