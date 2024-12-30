defmodule Aoc2018.Day18 do
  @moduledoc false

  @input_file "../inputs/day18.txt"

  @open_ground ?.
  @trees ?|
  @lumberyard ?#

  @adjacents [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.to_charlist()
      |> Enum.with_index(&{{&2, y}, parse_acre(&1)})
    end)
    |> Map.new()
  end

  defp parse_acre(@open_ground), do: :open_ground
  defp parse_acre(@trees), do: :trees
  defp parse_acre(@lumberyard), do: :lumberyard

  defp next_time_acre(acre, adjacents)

  defp next_time_acre(:open_ground, adjacents) do
    if Enum.count(adjacents, &(&1 == :trees)) >= 3,
      do: :trees,
      else: :open_ground
  end

  defp next_time_acre(:trees, adjacents) do
    if Enum.count(adjacents, &(&1 == :lumberyard)) >= 3,
      do: :lumberyard,
      else: :trees
  end

  defp next_time_acre(:lumberyard, adjacents) do
    if Enum.any?(adjacents, &(&1 == :lumberyard)) && Enum.any?(adjacents, &(&1 == :trees)),
      do: :lumberyard,
      else: :open_ground
  end

  defp get_adjacents({acre_pos_x, acre_pos_y} = _acre_pos, area) do
    @adjacents
    |> Enum.map(fn {x, y} -> area[{x + acre_pos_x, y + acre_pos_y}] end)
    |> Enum.reject(&is_nil/1)
  end

  defp next_time(area) do
    area
    |> Map.keys()
    |> Enum.reduce(%{}, &Map.put(&2, &1, next_time_acre(area[&1], get_adjacents(&1, area))))
  end

  defp total(area) do
    final_area = Map.values(area)

    [:trees, :lumberyard]
    |> Enum.map(fn type -> Enum.count(final_area, &(&1 == type)) end)
    |> Enum.product()
  end

  def solution1(input) do
    area = parse_input(input)
    time_max = 10

    1..time_max
    |> Enum.reduce(area, fn _time, area_acc -> next_time(area_acc) end)
    |> total()
  end

  def solution2(input) do
    area = parse_input(input)
    time_max = 1_000_000_000

    area_list =
      {area, MapSet.new()}
      |> Stream.iterate(fn {area, area_save} ->
        {next_time(area), MapSet.put(area_save, area)}
      end)
      |> Stream.take_while(fn {area, area_save} ->
        area not in area_save
      end)
      |> Enum.map(&elem(&1, 0))

    start_scheme_idx = Enum.find_index(area_list, &(&1 == next_time(List.last(area_list))))
    scheme_length = length(area_list) - start_scheme_idx

    area_list
    |> Enum.at(start_scheme_idx + rem(time_max - start_scheme_idx, scheme_length))
    |> total()
  end

  @doc """
  iex> Aoc2018.Day18.part1()
  481290
  """
  def part1 do
    File.read!(@input_file)
    |> solution1()
  end

  @doc """
  iex> Aoc2018.Day18.part2()
  180752
  """
  def part2 do
    File.read!(@input_file)
    |> solution2()
  end
end
