defmodule Aoc2018Test.Day02Test do
  @moduledoc false

  use ExUnit.Case
  import Aoc2018.Day02

  doctest Aoc2018.Day02

  @test_input """
  abcdef
  bababc
  abbcde
  abcccd
  aabcdd
  abcdee
  ababab
  """
  @test_input_2 """
  abcde
  fghij
  klmno
  pqrst
  fguij
  axcye
  wvxyz
  """

  test "Day02 Test1" do
    assert solution1(@test_input) == 12
  end

  test "Day02 Test2" do
    assert solution2(@test_input_2) == "fgij"
  end
end
