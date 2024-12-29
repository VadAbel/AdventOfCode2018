defmodule Aoc2018.Day17 do
  @moduledoc false

  @input_file "../inputs/day17.txt"

  @water_spring {500, 0}

  defp parse_input(input) do
    clay =
      input
      |> String.split("\n", trim: true)
      |> Enum.flat_map(fn line ->
        [c1, v1, c2, v2, v3] = String.split(line, ["=", ", ", ".."], trim: true)

        case {c1, c2, String.to_integer(v1), String.to_integer(v2), String.to_integer(v3)} do
          {"x", "y", v1, v2, v3} -> Enum.map(Range.new(v2, v3), &{v1, &1})
          {"y", "x", v1, v2, v3} -> Enum.map(Range.new(v2, v3), &{&1, v1})
        end
      end)

    {y_min, y_max} =
      clay
      |> Enum.map(&elem(&1, 1))
      |> Enum.min_max()

    %{
      clay: MapSet.new(clay),
      y_min: y_min,
      y_max: y_max,
      drop_water: MapSet.new(),
      stay_water: MapSet.new()
    }
  end

  defp move_down({a_x, a_y} = active_water, ground) do
    under = {a_x, a_y + 1}

    cond do
      a_y > ground.y_max -> ground
      under in ground.clay -> spread(active_water, ground)
      under in ground.stay_water -> spread(active_water, ground)
      under in ground.drop_water -> update_in(ground.drop_water, &MapSet.put(&1, active_water))
      true -> move_down(under, update_in(ground.drop_water, &MapSet.put(&1, active_water)))
    end
  end

  defp spread({a_x, a_y} = active_water, ground) do
    line =
      Enum.reduce([-1, 1], MapSet.new(), fn dir, acc ->
        Stream.iterate(active_water, fn {a_x, a_y} -> {a_x + dir, a_y} end)
        |> Enum.take_while(fn {a_x, a_y} ->
          ({a_x, a_y + 1} in ground.clay || {a_x, a_y + 1} in ground.stay_water) &&
            {a_x, a_y} not in ground.clay
        end)
        |> MapSet.new()
        |> MapSet.union(acc)
      end)

    {{l_x, l_y}, {r_x, r_y}} = Enum.min_max(line)

    if {l_x - 1, l_y} in ground.clay && {r_x + 1, r_y} in ground.clay do
      spread({a_x, a_y - 1}, update_in(ground.stay_water, &MapSet.union(&1, line)))
    else
      [{l_x - 1, l_y}, {r_x + 1, r_y}]
      |> Enum.reject(&(&1 in ground.clay))
      |> Enum.reduce(ground, fn fall_water, ground_acc ->
        move_down(fall_water, update_in(ground_acc.drop_water, &MapSet.union(&1, line)))
      end)
    end
  end

  def visualize(ground, part) do
    {x_min, x_max} =
      ground.clay
      |> Enum.map(&elem(&1, 0))
      |> Enum.min_max()

    char_func = fn cell, ground ->
      cond do
        cell == @water_spring -> "+"
        cell in ground.clay -> "#"
        cell in ground.stay_water -> "~"
        cell in ground.drop_water && part == 1 -> "|"
        true -> " "
      end
    end

    0..ground.y_max
    |> Enum.map_join("\n", fn y ->
      (x_min - 1)..(x_max + 1)
      |> Enum.map_join(fn x -> char_func.({x, y}, ground) end)
    end)
    |> IO.puts()
  end

  def solution1(input) do
    ground = parse_input(input)

    move_down(@water_spring, ground)
    # |> tap(&visualize(&1, 1))
    |> then(&MapSet.union(&1.drop_water, &1.stay_water))
    |> MapSet.to_list()
    |> Enum.filter(fn {_x, y} -> y in ground.y_min..ground.y_max end)
    |> length()
  end

  def solution2(input) do
    ground = parse_input(input)

    move_down(@water_spring, ground)
    # |> tap(&visualize(&1, 2))
    |> Map.get(:stay_water)
    |> MapSet.to_list()
    |> Enum.filter(fn {_x, y} -> y in ground.y_min..ground.y_max end)
    |> length()
  end

  @doc """
  iex> Aoc2018.Day17.part1()
  34244
  """
  def part1 do
    File.read!(@input_file)
    |> solution1()
  end

  @doc """
  iex> Aoc2018.Day17.part2()
  28202
  """
  def part2 do
    File.read!(@input_file)
    |> solution2()
  end
end
