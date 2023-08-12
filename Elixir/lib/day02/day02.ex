defmodule Aoc2018.Day02 do
  @moduledoc false

  @input_file "../inputs/day02.txt"

  defp has_exactly_count(list, count) do
    if(Enum.any?(list, &(&1 == count)), do: 1, else: 0)
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
  end

  defp pair_boxes(list) do
    list
    |> Stream.scan([], &[&1 | &2])
    |> Stream.flat_map(fn
      [x | list] -> Enum.map(list, &{x, &1})
      _ -> []
    end)
  end

  def solution1(input) do
    input
    |> parse_input()
    |> Enum.map(fn box ->
      box
      |> Enum.frequencies()
      |> Map.values()
      |> then(fn list ->
        [2, 3]
        |> Enum.map(&has_exactly_count(list, &1))
      end)
    end)
    |> Enum.zip()
    |> Enum.map(&Tuple.sum(&1))
    |> Enum.product()
  end

  def solution2(input) do
    input
    |> parse_input()
    |> pair_boxes()
    |> Enum.reduce_while(:error, fn {l, r}, acc ->
      diff_index =
        Enum.zip(l, r)
        |> Enum.with_index()
        |> Enum.reduce([], fn
          {{char, char}, _index}, acc -> acc
          {_, index}, acc -> [index | acc]
        end)

      case diff_index do
        [index] -> {:halt, l |> List.delete_at(index) |> List.to_string()}
        _ -> {:cont, acc}
      end
    end)
  end

  @doc """
  iex> Aoc2018.Day02.part1()
  7470
  """
  def part1 do
    File.read!(@input_file)
    |> solution1()
  end

  @doc """
  iex> Aoc2018.Day02.part2()
  "kqzxdenujwcstybmgvyiofrrd"
  """
  def part2 do
    File.read!(@input_file)
    |> solution2()
  end
end
