defmodule Aoc2018Test.Day01Test do
  @moduledoc false

  use ExUnit.Case
  import Aoc2018.Day01

  doctest Aoc2018.Day01

  @test_input "+1, -2, +3, +1"

  test "Day01 Test1" do
    assert solution1(@test_input) == 3
    assert solution1("+1, +1, +1") == 3
    assert solution1("+1, +1, -2") == 0
    assert solution1("-1, -2, -3") == -6
  end

  test "Day01 Test2" do
    assert solution2(@test_input) == 2
    assert solution2("+1, -1") == 0
    assert solution2("+3, +3, +4, -2, -4") == 10
    assert solution2("-6, +3, +8, +5, -6") == 5
    assert solution2("+7, +7, -2, -7, -4") == 14
  end
end
