defmodule Aoc2018.Day09 do
  @moduledoc false

  @input_file "../inputs/day09.txt"

  defp process_turn({turn, board, scores}, nb_player) when rem(turn, 23) == 0 do
    {[x | tail_stack], buffer} = roll_board(board, -7)
    new_board = {tail_stack, buffer}

    new_scores =
      update_in(scores, [Access.key(rem(turn - 1, nb_player) + 1, 0)], &(&1 + x + turn))

    {turn, new_board, new_scores}
  end

  defp process_turn({turn, board, scores}, _nb_player) do
    {stack, buffer} = roll_board(board, 2)
    new_board = {[turn | stack], buffer}

    {turn, new_board, scores}
  end

  defp roll_board({[], buffer}, count) when count >= 0,
    do: roll_board({Enum.reverse(buffer), []}, count)

  defp roll_board({stack, []}, count) when count < 0,
    do: roll_board({[], Enum.reverse(stack)}, count)

  defp roll_board({stack, buffer}, 0),
    do: {stack, buffer}

  defp roll_board({[x | tail_stack], buffer}, count) when count > 0,
    do: roll_board({tail_stack, [x | buffer]}, count - 1)

  defp roll_board({stack, [x | tail_buffer]}, count) when count < 0,
    do: roll_board({[x | stack], tail_buffer}, count + 1)

  defp parse_input(input) do
    split_input = input |> String.split()

    Enum.map(
      [0, 6],
      fn x -> Enum.at(split_input, x) |> String.to_integer() end
    )
  end

  def solution1(input) do
    [nb_player, last_marble] = parse_input(input)

    start_board = {[0], []}
    start_scores = %{}
    start_turn = 0

    Stream.iterate(
      {start_turn, start_board, start_scores},
      fn {turn, board, scores} ->
        process_turn({turn + 1, board, scores}, nb_player)
      end
    )
    |> Enum.at(last_marble)
    |> elem(2)
    |> Map.values()
    |> Enum.max()
  end

  def solution2(input) do
    [nb_player, last_marble] = parse_input(input)

    start_board = {[0], []}
    start_scores = %{}
    start_turn = 0

    Stream.iterate(
      {start_turn, start_board, start_scores},
      fn {turn, board, scores} ->
        process_turn({turn + 1, board, scores}, nb_player)
      end
    )
    |> Enum.at(last_marble * 100)
    |> elem(2)
    |> Map.values()
    |> Enum.max()
  end

  @doc """
  iex> Aoc2018.Day09.part1()
  424112
  """
  def part1 do
    File.read!(@input_file)
    |> solution1()
  end

  @doc """
  iex> Aoc2018.Day09.part2()
  3487352628
  """
  def part2 do
    File.read!(@input_file)
    |> solution2()
  end
end
