defmodule Aoc2018.Day05 do
  @moduledoc false

  @input_file "../inputs/day05.txt"

  defp process_reduction(list, processed \\ [])

  defp process_reduction([a], processed),
    do: [a | processed]

  defp process_reduction([a, b | rest], []) when abs(a - b) == 32,
    do: process_reduction(rest, [])

  defp process_reduction([a, b | rest], processed) when abs(a - b) == 32,
    do: process_reduction([hd(processed) | rest], tl(processed))

  defp process_reduction([a, b | rest], processed),
    do: process_reduction([b | rest], [a | processed])

  defp parse_input(input),
    do: String.to_charlist(input)

  def solution1(input) do
    input
    |> parse_input()
    |> process_reduction()
    |> Enum.count()
  end

  def solution2(input) do
    input_charlist = parse_input(input)

    input_charlist
    |> Enum.filter(&(&1 in ?A..?Z))
    |> Enum.uniq()
    |> Enum.map(fn char ->
      input_charlist
      |> Enum.reject(&(&1 in [char, char + 32]))
      |> process_reduction()
      |> Enum.count()
    end)
    |> Enum.min()
  end

  @doc """
  iex> Aoc2018.Day05.part1()
  10886
  """
  def part1 do
    File.read!(@input_file)
    |> solution1()
  end

  @doc """
  iex> Aoc2018.Day05.part2()
  4684
  """
  def part2 do
    File.read!(@input_file)
    |> solution2()
  end
end
