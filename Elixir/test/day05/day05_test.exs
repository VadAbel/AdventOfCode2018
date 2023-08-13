defmodule Aoc2018Test.Day05Test do
  @moduledoc false

  use ExUnit.Case
  import Aoc2018.Day05

  doctest Aoc2018.Day05

  @test_input "dabAcCaCBAcCcaDA"

  test "Day05 Test1" do
    assert solution1(@test_input) == 10
  end

  test "Day05 Test2" do
    assert solution2(@test_input) == 4
  end
end
