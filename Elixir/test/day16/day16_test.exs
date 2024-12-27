defmodule Aoc2018Test.Day16Test do
  @moduledoc false

  use ExUnit.Case
  import Aoc2018.Day16

  doctest Aoc2018.Day16

  @test_input """
  Before: [3, 2, 1, 1]
  9 2 1 2
  After:  [3, 2, 2, 1]
  """

  test "Day16 Test1" do
    assert solution1(@test_input) == 1
  end

  test "Day16 Test2" do
    # assert solution2(@test_input) == nil
  end
end
