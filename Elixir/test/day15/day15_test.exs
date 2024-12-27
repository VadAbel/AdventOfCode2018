defmodule Aoc2018Test.Day15Test do
  @moduledoc false

  use ExUnit.Case
  import Aoc2018.Day15

  doctest Aoc2018.Day15

  @test_input """
  #######
  #.G...#
  #...EG#
  #.#.#G#
  #..G#E#
  #.....#
  #######
  """

  @test_input2 """
  #######
  #G..#E#
  #E#E.E#
  #G.##.#
  #...#E#
  #...E.#
  #######
  """

  @test_input3 """
  #######
  #E..EG#
  #.#G.E#
  #E.##E#
  #G..#.#
  #..E#.#
  #######
  """

  @test_input4 """
  #######
  #E.G#.#
  #.#G..#
  #G.#.G#
  #G..#.#
  #...E.#
  #######
  """

  @test_input5 """
  #######
  #.E...#
  #.#..G#
  #.###.#
  #E#G#G#
  #...#G#
  #######
  """

  @test_input6 """
  #########
  #G......#
  #.E.#...#
  #..##..G#
  #...##..#
  #...#...#
  #.G...G.#
  #.....G.#
  #########
  """

  test "Day15 Test1" do
    assert solution1(@test_input) == 27_730
    assert solution1(@test_input2) == 36_334
    assert solution1(@test_input3) == 39_514
    assert solution1(@test_input4) == 27_755
    assert solution1(@test_input5) == 28_944
    assert solution1(@test_input6) == 18_740
  end

  test "Day15 Test2" do
    assert solution2(@test_input) == 4_988
    assert solution2(@test_input3) == 31_284
    assert solution2(@test_input4) == 3_478
    assert solution2(@test_input5) == 6_474
    assert solution2(@test_input6) == 1_140
  end
end
