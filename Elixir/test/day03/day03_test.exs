defmodule Aoc2018Test.Day03Test do
  @moduledoc false

  use ExUnit.Case
  import Aoc2018.Day03

  doctest Aoc2018.Day03

  @test_input """
  #1 @ 1,3: 4x4
  #2 @ 3,1: 4x4
  #3 @ 5,5: 2x2
  """

  test "Day03 Test1" do
    assert solution1(@test_input) == 4
  end

  test "Day03 Test2" do
    assert solution2(@test_input) == 3
  end
end
