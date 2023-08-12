defmodule Aoc2018.Day03 do
  @moduledoc false

  @input_file "../inputs/day03.txt"

  defp fabric_claims(claims) do
    claims
    |> Enum.reduce(%{}, fn
      {claim_id, {left, top}, {width, height}}, acc ->
        for x <- left..(left + width - 1),
            y <- top..(top + height - 1),
            reduce: acc do
          acc -> Map.update(acc, {x, y}, [claim_id], &[claim_id | &1])
        end
    end)
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn claim ->
      [claim_id, left, top, width, height] =
        claim
        |> String.split(["#", " ", "@", ",", ":", "x"], trim: true)
        |> Enum.map(&String.to_integer/1)

      {claim_id, {left, top}, {width, height}}
    end)
  end

  def solution1(input) do
    input
    |> parse_input()
    |> fabric_claims()
    |> Enum.count(fn {_coord, claims} -> if length(claims) > 1, do: true, else: false end)
  end

  def solution2(input) do
    claims = parse_input(input)

    overlap_claims =
      claims
      |> fabric_claims()
      |> Map.values()
      |> Enum.filter(&(length(&1) > 1))
      |> List.flatten()
      |> Enum.uniq()

    claims
    |> Enum.map(fn {claim_id, _, _} -> claim_id end)
    |> Enum.reject(&(&1 in overlap_claims))
    |> hd()
  end

  @doc """
  iex> Aoc2018.Day03.part1()
  111266
  """
  def part1 do
    File.read!(@input_file)
    |> solution1()
  end

  @doc """
  iex> Aoc2018.Day03.part2()
  266
  """
  def part2 do
    File.read!(@input_file)
    |> solution2()
  end
end
