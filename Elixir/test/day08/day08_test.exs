defmodule Aoc2018Test.Day08Test do
  @moduledoc false

  use ExUnit.Case
  import Aoc2018.Day08

  doctest Aoc2018.Day08

  @test_input "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"

  test "Day08 Test1" do
    assert solution1(@test_input) == 138
  end

  test "Day08 Test2" do
    assert solution2(@test_input) == 66
  end
end
