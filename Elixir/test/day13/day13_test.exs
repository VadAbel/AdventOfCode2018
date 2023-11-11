defmodule Aoc2018Test.Day13Test do
  @moduledoc false

  use ExUnit.Case
  import Aoc2018.Day13

  doctest Aoc2018.Day13

  @test_input """
  /->-\\
  |   |  /----\\
  | /-+--+-\\  |
  | | |  | v  |
  \\-+-/  \\-+--/
    \\------/
  """

  @test_input_2 """
  />-<\\
  |   |
  | /<+-\\
  | | | v
    \\>+</ |
    |   ^
    \\<->/
  """

  test "Day13 Test1" do
    assert solution1(@test_input) == "7,3"
  end

  test "Day13 Test2" do
    assert solution2(@test_input_2) == "6,4"
  end
end
