defmodule Aoc2018Test.Day17Test do
  @moduledoc false

  use ExUnit.Case
  import Aoc2018.Day17

  doctest Aoc2018.Day17

  @test_input """
  x=495, y=2..7
  y=7, x=495..501
  x=501, y=3..7
  x=498, y=2..4
  x=506, y=1..2
  x=498, y=10..13
  x=504, y=10..13
  y=13, x=498..504
  """

  test "Day17 Test1" do
    assert solution1(@test_input) == 57
  end

  test "Day17 Test2" do
    assert solution2(@test_input) == 29
  end
end
