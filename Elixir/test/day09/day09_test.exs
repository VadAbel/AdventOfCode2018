defmodule Aoc2018Test.Day09Test do
  @moduledoc false

  use ExUnit.Case
  import Aoc2018.Day09

  doctest Aoc2018.Day09

  # @test_input """
  # """

  test "Day09 Test1" do
    assert solution1("9 players; last marble is worth 25 points") == 32
    assert solution1("10 players; last marble is worth 1618 points") == 8317
    assert solution1("13 players; last marble is worth 7999 points") == 146_373
    assert solution1("17 players; last marble is worth 1104 points") == 2764
    assert solution1("21 players; last marble is worth 6111 points") == 54_718
    assert solution1("30 players; last marble is worth 5807 points") == 37_305
  end

  test "Day09 Test2" do
    # assert solution2(@test_input) == nil
  end
end
