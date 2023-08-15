defmodule Aoc2018.Day06 do
  @moduledoc false

  @input_file "../inputs/day06.txt"

  defp manhattan_distance({x1, y1}, {x2, y2}), do: abs(x2 - x1) + abs(y2 - y1)

  defp calc_limit({x_point, y_point}, input_points) do
    [{-1, 0}, {0, -1}, {1, 0}, {0, 1}]
    |> Enum.reverse()
    |> Enum.reduce_while([], fn {x_dir, y_dir}, acc ->
      l =
        input_points
        |> Enum.filter(fn {x1, y1} ->
          delta_x = x1 - x_point
          delta_y = y1 - y_point

          x_dir * delta_x + y_dir * delta_y > 0 and
            abs(x_dir * delta_x + y_dir * delta_y) - abs(y_dir * delta_x + x_dir * delta_y) >= 0
        end)

      case l do
        [] ->
          {:halt, :infinite}

        _ ->
          {:cont,
           [
             Enum.map(l, &(manhattan_distance(&1, {x_point, y_point}) |> div(2)))
             |> Enum.min()
             |> then(&(&1 * (x_dir + y_dir) + (x_point * abs(x_dir) + y_point * abs(y_dir))))
             | acc
           ]}
      end
    end)
  end

  defp nearest_point(point_origin, input_points) do
    distances =
      Enum.map(input_points, &{&1, manhattan_distance(&1, point_origin)})
      |> Enum.sort_by(fn {_point, distance} -> distance end)

    case distances do
      [{near_point, _}] -> near_point
      [{dup_point, _}, {dup_point, _} | _] -> :none
      [{near_point, _} | _] -> near_point
    end
  end

  defp area_size(point, [x_min, y_min, x_max, y_max], input_points) do
    for x <- x_min..x_max,
        y <- y_min..y_max,
        point == nearest_point({x, y}, input_points) do
      {x, y}
    end
    |> Enum.count()
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn point ->
      point
      |> String.split(", ", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  def solution1(input) do
    input_points = parse_input(input)

    input_points
    |> Enum.map(fn point -> {point, calc_limit(point, input_points -- [point])} end)
    |> Enum.reject(&(elem(&1, 1) == :infinite))
    |> Enum.map(fn {point, [x_min, y_min, x_max, y_max]} ->
      {point, [x_min, y_min, x_max, y_max], abs(x_max - x_min) * abs(y_max - y_min)}
    end)
    |> Enum.sort_by(&elem(&1, 2), :desc)
    |> Enum.reduce(
      {nil, 0},
      fn
        {point, point_zone, potential_size}, {acc_point, acc_size}
        when potential_size > acc_size ->
          point_size = area_size(point, point_zone, input_points)

          if point_size > acc_size do
            {point, point_size}
          else
            {acc_point, acc_size}
          end

        _, {acc_point, acc_size} ->
          {acc_point, acc_size}
      end
    )
    |> elem(1)
  end

  def solution2(input, limit \\ 10_000) do
    input_points = parse_input(input)

    [{x_min, x_max}, {y_min, y_max}] =
      [0, 1]
      |> Enum.map(fn pos ->
        input_points
        |> Enum.map(&elem(&1, pos))
        |> Enum.min_max()
      end)

    for x <- x_min..x_max,
        y <- y_min..y_max do
      input_points
      |> Enum.map(&manhattan_distance({x, y}, &1))
      |> Enum.sum()
    end
    |> Enum.count(&(&1 < limit))
  end

  @doc """
  iex> Aoc2018.Day06.part1()
  3604
  """
  def part1 do
    File.read!(@input_file)
    |> solution1()
  end

  @doc """
  iex> Aoc2018.Day06.part2()
  46563
  """
  def part2 do
    File.read!(@input_file)
    |> solution2()
  end
end
