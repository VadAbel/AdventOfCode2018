defmodule Aoc2018.Day01 do
  @moduledoc false

  @input_file "../inputs/day01.txt"

  defp parse_input(input) do
    input
    |> String.split([", ", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def solution1(input) do
    input
    |> parse_input()
    |> Enum.sum()
  end

  def solution2(input) do
    input
    |> parse_input()
    |> Stream.cycle()
    |> Enum.reduce_while({0, MapSet.new([0])}, fn x, {sum, old_freqs} ->
      new_sum = x + sum

      if MapSet.member?(old_freqs, new_sum) do
        {:halt, new_sum}
      else
        {:cont, {new_sum, MapSet.put(old_freqs, new_sum)}}
      end
    end)
  end

  @doc """
  iex> Aoc2018.Day01.part1()
  445
  """
  def part1 do
    File.read!(@input_file)
    |> solution1()
  end

  @doc """
  iex> Aoc2018.Day01.part2()
  219
  """
  def part2 do
    File.read!(@input_file)
    |> solution2()
  end
end
