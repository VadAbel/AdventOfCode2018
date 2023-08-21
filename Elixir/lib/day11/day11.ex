defmodule Aoc2018.Day11 do
  @moduledoc false

  @input_file "../inputs/day11.txt"

  defp smart_find_square(serial, grid_size, size_limit) do
    for s <- 1..size_limit,
        x <- 1..(grid_size - s + 1),
        y <- 1..(grid_size - s + 1),
        reduce: {-10, {nil, nil, 0}, %{}} do
      {max_power, {_, _, max_size} = max_square, sum_grid} ->
        {square_power, sum_grid} =
          compute_square_power(x, y, s, serial, sum_grid)

        if square_power > max_power or (square_power == max_power and s > max_size) do
          {square_power, {x, y, s}, sum_grid}
        else
          {max_power, max_square, sum_grid}
        end
    end
    |> elem(1)
  end

  defp compute_square_power(x, y, s, serial, sum_grid) do
    # https://en.wikipedia.org/wiki/Summed-area_table
    # a, b, c ,d
    {a, sum_grid} = get_value(sum_grid, {x - 1, y - 1}, serial)
    {b, sum_grid} = get_value(sum_grid, {x - 1, y + s - 1}, serial)
    {c, sum_grid} = get_value(sum_grid, {x + s - 1, y - 1}, serial)
    {d, sum_grid} = get_value(sum_grid, {x + s - 1, y + s - 1}, serial)

    square_power = d - c - b + a

    {square_power, sum_grid}
  end

  defp get_value(sum_grid, {x, y}, _serial) when x < 1 or y < 1 do
    {0, sum_grid}
  end

  defp get_value(sum_grid, {x, y}, _serial) when is_map_key(sum_grid, {x, y}) do
    {Map.get(sum_grid, {x, y}), sum_grid}
  end

  defp get_value(sum_grid, {x, y}, serial) do
    # a, b, c, d
    {a, sum_grid} = get_value(sum_grid, {x - 1, y - 1}, serial)
    {b, sum_grid} = get_value(sum_grid, {x - 1, y}, serial)
    {c, sum_grid} = get_value(sum_grid, {x, y - 1}, serial)

    rack_id = x + 10

    power_level =
      ((rack_id * y + serial) * rack_id)
      |> div(100)
      |> rem(10)
      |> then(&(&1 - 5))

    d = b + c - a + power_level

    sum_grid = Map.put_new(sum_grid, {x, y}, d)

    {d, sum_grid}
  end

  defp make_grid(serial, size_limit) do
    for x <- 1..size_limit, y <- 1..size_limit, into: %{} do
      rack_id = x + 10

      power_level =
        ((rack_id * y + serial) * rack_id)
        |> div(100)
        |> rem(10)
        |> then(&(&1 - 5))

      {{x, y}, power_level}
    end
  end

  defp compute_square(grid, size_limit, square_size_limit \\ 3) do
    for s <- square_size_limit..3//-1,
        x <- 1..(size_limit - s + 1),
        y <- 1..(size_limit - s + 1) do
      square_power =
        square_range(x, y, s)
        |> Enum.map(&grid[&1])
        |> Enum.sum()

      {{x, y, s}, square_power}
    end
  end

  defp square_range(x_orig, y_orig, size) do
    for x <- x_orig..(x_orig + size - 1),
        y <- y_orig..(y_orig + size - 1) do
      {x, y}
    end
  end

  defp parse_input(input) do
    String.to_integer(input)
  end

  def solution1(input, size_limit \\ 300) do
    input
    |> parse_input()
    |> make_grid(size_limit)
    |> compute_square(size_limit)
    |> Enum.max_by(&elem(&1, 1))
    |> elem(0)
    |> Tuple.to_list()
    |> Enum.drop(-1)
    |> Enum.join(",")
  end

  def solution2(input, size_limit \\ 300) do
    input
    |> parse_input()
    |> smart_find_square(size_limit, size_limit)
    |> Tuple.to_list()
    |> Enum.join(",")

    # input
    # |> parse_input()
    # |> make_grid(size_limit)
    # |> compute_square(size_limit, 20)
    # |> Enum.max_by(fn {{_, _, s}, p} -> p * 1000 + s end)
    # |> elem(0)
    # |> Tuple.to_list()
    # |> Enum.join(",")
  end

  @doc """
  iex> Aoc2018.Day11.part1()
  "245,14"
  """
  def part1 do
    File.read!(@input_file)
    |> solution1()
  end

  @doc """
  iex> Aoc2018.Day11.part2()
  "235,206,13"
  """
  def part2 do
    File.read!(@input_file)
    |> solution2()
  end
end
