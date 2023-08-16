defmodule Aoc2018.Day08 do
  @moduledoc false

  @input_file "../inputs/day08.txt"

  defp build_tree(license) do
    build_child(license)
    |> elem(0)
  end

  defp build_child([nb_child, nb_metadata | tail_license]) do
    {childs, tail} =
      1..nb_child//1
      |> Enum.flat_map_reduce(tail_license, fn _, acc ->
        {child, tail} =
          build_child(acc)

        {[child], tail}
      end)

    {metadata, tail} = Enum.split(tail, nb_metadata)

    {%{childs: childs, metadata: metadata}, tail}
  end

  defp sum_metadata(%{childs: childs, metadata: metadata}, sum_func) do
    childs_metadata = Enum.map(childs, &sum_metadata(&1, sum_func))

    sum_func.(childs_metadata, metadata)
  end

  defp parse_input(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  def solution1(input) do
    sum_func = fn childs_metadata, metadata -> Enum.sum(childs_metadata) + Enum.sum(metadata) end

    input
    |> parse_input()
    |> build_tree()
    |> sum_metadata(sum_func)
  end

  def solution2(input) do
    sum_func = fn
      [], metadata ->
        Enum.sum(metadata)

      childs_metadata, metadata ->
        Enum.reduce(metadata, 0, fn m, acc -> acc + Enum.at(childs_metadata, m - 1, 0) end)
    end

    input
    |> parse_input()
    |> build_tree()
    |> sum_metadata(sum_func)
  end

  @doc """
  iex> Aoc2018.Day08.part1()
  40848
  """
  def part1 do
    File.read!(@input_file)
    |> solution1()
  end

  @doc """
  iex> Aoc2018.Day08.part2()
  34466
  """
  def part2 do
    File.read!(@input_file)
    |> solution2()
  end
end
