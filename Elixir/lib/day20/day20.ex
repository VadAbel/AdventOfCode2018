defmodule Aoc2018.Day20 do
  @moduledoc false

  @input_file "../inputs/day20.txt"

  defp parse_input(input),
    do: String.to_charlist(input)

  defp move(dir, pos)
  defp move(?W, {x, y}), do: {x - 1, y}
  defp move(?N, {x, y}), do: {x, y + 1}
  defp move(?S, {x, y}), do: {x, y - 1}
  defp move(?E, {x, y}), do: {x + 1, y}

  defp step(route, pos, rooms, stack_pos)

  defp step([?^ | rest], pos, rooms, stack_pos),
    do: step(rest, pos, rooms, stack_pos)

  defp step([?$], _pos, rooms, _stack_pos),
    do: rooms

  defp step([?( | rest], pos, rooms, stack_pos),
    do: step(rest, pos, rooms, [pos | stack_pos])

  defp step([?| | rest], _pos, rooms, stack_pos),
    do: step(rest, hd(stack_pos), rooms, stack_pos)

  defp step([?) | rest], _pos, rooms, stack_pos),
    do: step(rest, hd(stack_pos), rooms, tl(stack_pos))

  defp step([dir | rest], pos, rooms, stack_pos) do
    next_pos = move(dir, pos)
    new_rooms = Map.update(rooms, next_pos, rooms[pos] + 1, &min(&1, rooms[pos] + 1))

    step(rest, next_pos, new_rooms, stack_pos)
  end

  def solution1(input) do
    input
    |> parse_input()
    |> step({0, 0}, %{{0, 0} => 0}, [])
    |> Map.values()
    |> Enum.max()
  end

  def solution2(input) do
    input
    |> parse_input()
    |> step({0, 0}, %{{0, 0} => 0}, [])
    |> Map.values()
    |> Enum.count(&(&1 >= 1000))
  end

  @doc """
  iex> Aoc2018.Day20.part1()
  4432
  """
  def part1 do
    File.read!(@input_file)
    |> solution1()
  end

  @doc """
  iex> Aoc2018.Day20.part2()
  8681
  """
  def part2 do
    File.read!(@input_file)
    |> solution2()
  end
end
