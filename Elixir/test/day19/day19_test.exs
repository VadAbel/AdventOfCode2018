defmodule Aoc2018Test.Day19Test do
  @moduledoc false

  use ExUnit.Case
  import Aoc2018.Day19

  doctest Aoc2018.Day19

  @test_input """
  #ip 0
  seti 5 0 1
  seti 6 0 2
  addi 0 1 0
  addr 1 2 3
  setr 1 0 0
  seti 8 0 4
  seti 9 0 5
  """

  test "Day19 Test1" do
    assert solution1(@test_input) == 6
  end

  test "Day19 Test2" do
    # assert solution2(@test_input) == nil
  end
end
