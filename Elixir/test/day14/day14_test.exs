defmodule Aoc2018Test.Day14Test do
  @moduledoc false

  use ExUnit.Case
  import Aoc2018.Day14

  doctest Aoc2018.Day14

  # @test_input """
  # """

  test "Day14 Test1" do
    assert solution1("9") == "5158916779"
    assert solution1("5") == "0124515891"
    assert solution1("18") == "9251071085"
    assert solution1("2018") == "5941429882"
  end

  test "Day14 Test2" do
    assert solution2("51589") == "9"
    assert solution2("01245") == "5"
    assert solution2("92510") == "18"
    assert solution2("59414") == "2018"
  end
end
