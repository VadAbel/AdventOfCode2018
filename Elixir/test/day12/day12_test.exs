defmodule Aoc2018Test.Day12Test do
  @moduledoc false

  use ExUnit.Case
  import Aoc2018.Day12

  doctest Aoc2018.Day12

  @test_input """
  initial state: #..#.#..##......###...###

  ...## => #
  ..#.. => #
  .#... => #
  .#.#. => #
  .#.## => #
  .##.. => #
  .#### => #
  #.#.# => #
  #.### => #
  ##.#. => #
  ##.## => #
  ###.. => #
  ###.# => #
  ####. => #
  """

  test "Day12 Test1" do
    assert solution1(@test_input) == 325
  end

  test "Day12 Test2" do
    # assert solution2(@test_input) == nil
  end
end
