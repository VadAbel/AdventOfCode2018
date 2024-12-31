defmodule Aoc2018Test.Day20Test do
  @moduledoc false

  use ExUnit.Case
  import Aoc2018.Day20

  doctest Aoc2018.Day20

  @test_input1 "^WNE$"
  @test_input2 "^ENWWW(NEEE|SSE(EE|N))$"
  @test_input3 "^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$"
  @test_input4 "^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$"
  @test_input5 "^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$"

  test "Day20 Test1" do
    assert solution1(@test_input1) == 3
    assert solution1(@test_input2) == 10
    assert solution1(@test_input3) == 18
    assert solution1(@test_input4) == 23
    assert solution1(@test_input5) == 31
  end

  test "Day20 Test2" do
    # assert solution2(@test_input) == nil
  end
end
