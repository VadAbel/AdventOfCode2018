defmodule Aoc2018.Day10 do
  @moduledoc false

  @input_file "../inputs/day10.txt"

  defp inc_position(light) do
    light
    |> update_in([:position, :x], &(&1 + light.velocity.x))
    |> update_in([:position, :y], &(&1 + light.velocity.y))
  end

  defp area_size({min_x, max_x, min_y, max_y}), do: (max_x - min_x) * (max_y - min_y)

  defp area_dim(lights) do
    {min_x, max_x} =
      lights
      |> get_in([Access.all(), :position, :x])
      |> Enum.min_max()

    {min_y, max_y} =
      lights
      |> get_in([Access.all(), :position, :y])
      |> Enum.min_max()

    {min_x, max_x, min_y, max_y}
  end

  defp have_lights(x, y, positions), do: if(%{x: x, y: y} in positions, do: ?#, else: ?.)

  defp make_printable({_time, _area_size, {min_x, max_x, min_y, max_y}, lights}) do
    positions = get_in(lights, [Access.all(), :position])

    min_y..max_y
    |> Enum.map_join("\n", fn y ->
      min_x..max_x
      |> Enum.map(&have_lights(&1, y, positions))
      |> List.to_string()
    end)
    |> then(&("\n" <> &1 <> "\n"))
  end

  defp find_message(lights) do
    lights
    |> Stream.iterate(fn lights -> Enum.map(lights, &inc_position(&1)) end)
    |> Stream.with_index()
    |> Stream.map(fn {lights, time} ->
      dim = area_dim(lights)

      size = area_size(dim)

      {time, size, dim, lights}
    end)
    |> Stream.chunk_every(2, 1)
    |> Stream.drop_while(fn [{_, a, _, _}, {_, b, _, _}] -> a > b end)
    |> Enum.at(0)
    |> hd()
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [pos_x, pos_y, vel_x, vel_y] =
        Regex.run(
          ~r/.*?(-?\d+), *(-?\d+)>.*?(-?\d+), *(-?\d+).*/,
          line,
          capture: :all_but_first
        )
        |> Enum.map(&String.to_integer/1)

      %{position: %{x: pos_x, y: pos_y}, velocity: %{x: vel_x, y: vel_y}}
    end)
  end

  def solution1(input) do
    input
    |> parse_input()
    |> find_message()
    |> make_printable()
  end

  def solution2(input) do
    input
    |> parse_input()
    |> find_message()
    |> elem(0)
  end

  @doc """
  iex> Aoc2018.Day10.part1()
  "\n#........####...#####....####...#####...#....#...####...#.....\n#.......#....#..#....#..#....#..#....#..#....#..#....#..#.....\n#.......#.......#....#..#.......#....#...#..#...#.......#.....\n#.......#.......#....#..#.......#....#...#..#...#.......#.....\n#.......#.......#####...#.......#####.....##....#.......#.....\n#.......#.......#.......#..###..#.........##....#..###..#.....\n#.......#.......#.......#....#..#........#..#...#....#..#.....\n#.......#.......#.......#....#..#........#..#...#....#..#.....\n#.......#....#..#.......#...##..#.......#....#..#...##..#.....\n######...####...#........###.#..#.......#....#...###.#..######\n"
  """

  def part1 do
    File.read!(@input_file)
    |> solution1()
  end

  # @doc """
  # iex> Aoc2018.Day10.part2()
  # 10639
  # """
  def part2 do
    File.read!(@input_file)
    |> solution2()
  end
end
