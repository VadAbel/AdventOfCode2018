defmodule Aoc2018Test.Day18Test do
  @moduledoc false

  use ExUnit.Case
  import Aoc2018.Day18

  doctest Aoc2018.Day18

  @test_input """
  .#.#...|#.
  .....#|##|
  .|..|...#.
  ..|#.....#
  #.#|||#|#|
  ...#.||...
  .|....|...
  ||...#|.#|
  |.||||..|.
  ...#.|..|.
  """

  test "Day18 Test1" do
    assert solution1(@test_input) == 1_147
  end

  test "Day18 Test2" do
    # assert solution2(@test_input) == nil
  end
end
