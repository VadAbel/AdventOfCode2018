defmodule Aoc2018.Day12 do
  @moduledoc false

  @input_file "../inputs/day12.txt"

  defp grow(pattern, offset, plant_combinaisons, gen_to_grow, gen \\ 0, past_pattern \\ %{})

  defp grow(pattern, offset, _plant_combinaisons, 0, _gen, _past_pattern) do
    Enum.map(pattern, &(&1 + offset))
  end

  defp grow(pattern, offset, plant_combinaison, gen_to_grow, gen, past_pattern)
       when is_map_key(past_pattern, pattern) do
    {past_offset, past_gen} = past_pattern[pattern]

    delta = gen - past_gen

    new_offset = offset + div(gen_to_grow, delta) * (offset - past_offset)

    new_gen_to_grow = rem(gen_to_grow, delta)

    grow(pattern, new_offset, plant_combinaison, new_gen_to_grow)
  end

  defp grow(pattern, offset, plant_combinaisons, gen_to_grow, gen, past_pattern) do
    {plant_min, plant_max} = Enum.min_max(pattern)

    {new_pattern, new_offset} =
      (plant_min - 2)..(plant_max + 2)
      |> Enum.reduce(MapSet.new(), fn idx, acc ->
        if Enum.filter(-2..2, &((&1 + idx) in pattern)) in plant_combinaisons do
          MapSet.put(acc, idx)
        else
          acc
        end
      end)
      |> nornalize_pattern(offset)

    new_past_pattern = Map.put(past_pattern, pattern, {offset, gen})

    grow(new_pattern, new_offset, plant_combinaisons, gen_to_grow - 1, gen + 1, new_past_pattern)
  end

  defp nornalize_pattern(pattern, offset \\ 0) do
    new_offset = Enum.min(pattern)

    normalized_pattern = Enum.map(pattern, &(&1 - new_offset))

    {normalized_pattern, offset + new_offset}
  end

  defp parse_input(input) do
    [initial_state | combinaisons] = String.split(input, "\n", trim: true)

    initial_state =
      initial_state
      |> String.split(" ")
      |> Enum.at(-1)
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.reduce(MapSet.new(), fn
        {?., _}, acc -> acc
        {?#, i}, acc -> MapSet.put(acc, i)
      end)

    plant_combinaisons =
      combinaisons
      |> Enum.map(&String.split(&1, " => ", trim: true))
      |> Enum.filter(fn [_, x] -> x == "#" end)
      |> Enum.map(fn [combinaison, _] ->
        combinaison
        |> String.to_charlist()
        |> Enum.with_index(-2)
        |> Enum.flat_map(fn
          {?#, i} -> [i]
          _ -> []
        end)
      end)
      |> Enum.into(MapSet.new())

    {initial_state, plant_combinaisons}
  end

  def solution1(input) do
    {initial_state, plant_combinaisions} = parse_input(input)

    {initial_pattern, offset} = nornalize_pattern(initial_state)

    grow(initial_pattern, offset, plant_combinaisions, 20)
    |> Enum.sum()
  end

  def solution2(input) do
    {initial_state, plant_combinaisions} = parse_input(input)

    {initial_pattern, offset} = nornalize_pattern(initial_state)

    grow(initial_pattern, offset, plant_combinaisions, 50_000_000_000)
    |> Enum.sum()
  end

  @doc """
  iex> Aoc2018.Day12.part1()
  4110
  """
  def part1 do
    File.read!(@input_file)
    |> solution1()
  end

  @doc """
  iex> Aoc2018.Day12.part2()
  2_650_000_000_466
  """
  def part2 do
    File.read!(@input_file)
    |> solution2()
  end
end
