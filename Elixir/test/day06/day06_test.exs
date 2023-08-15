defmodule Aoc2018Test.Day06Test do
  @moduledoc false

  use ExUnit.Case
  import Aoc2018.Day06

  doctest Aoc2018.Day06

  @test_input """
  1, 1
  1, 6
  8, 3
  3, 4
  5, 5
  8, 9
  """

  test "Day06 Test1" do
    assert solution1(@test_input) == 17
  end

  test "Day06 Test2" do
    assert solution2(@test_input, 32) == 16
  end
end
