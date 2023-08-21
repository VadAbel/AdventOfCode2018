defmodule Aoc2018Test.Day11Test do
  @moduledoc false

  use ExUnit.Case
  import Aoc2018.Day11

  doctest Aoc2018.Day11

  # @test_input ""

  test "Day11 Test1" do
    assert solution1("18") == "33,45"
    assert solution1("42") == "21,61"
  end

  test "Day11 Test2" do
    assert solution2("18") == "90,269,16"
    assert solution2("42") == "232,251,12"
  end
end
