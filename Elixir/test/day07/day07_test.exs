defmodule Aoc2018Test.Day07Test do
  @moduledoc false

  use ExUnit.Case
  import Aoc2018.Day07

  doctest Aoc2018.Day07

  @test_input """
  Step C must be finished before step A can begin.
  Step C must be finished before step F can begin.
  Step A must be finished before step B can begin.
  Step A must be finished before step D can begin.
  Step B must be finished before step E can begin.
  Step D must be finished before step E can begin.
  Step F must be finished before step E can begin.
  """

  test "Day07 Test1" do
    assert solution1(@test_input) == "CABDFE"
  end

  test "Day07 Test2" do
    assert solution2(@test_input, 0, 2) == 15
  end
end
