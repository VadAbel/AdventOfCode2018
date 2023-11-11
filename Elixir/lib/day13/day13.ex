defmodule Aoc2018.Day13 do
  @moduledoc false

  @input_file "../inputs/day13.txt"

  @north {0, -1}
  @east {1, 0}
  @south {0, 1}
  @west {-1, 0}

  defp move_cart({pos_x, pos_y}, {dir_x, dir_y}), do: {pos_x + dir_x, pos_y + dir_y}

  defp turn_cart({dir_x, dir_y}, :left, ?+), do: {{dir_y, -dir_x}, :forward}
  defp turn_cart({dir_x, dir_y}, :forward, ?+), do: {{dir_x, dir_y}, :right}
  defp turn_cart({dir_x, dir_y}, :right, ?+), do: {{-dir_y, dir_x}, :left}
  defp turn_cart(@north, next_turn, ?/), do: {@east, next_turn}
  defp turn_cart(@east, next_turn, ?/), do: {@north, next_turn}
  defp turn_cart(@south, next_turn, ?/), do: {@west, next_turn}
  defp turn_cart(@west, next_turn, ?/), do: {@south, next_turn}
  defp turn_cart(@north, next_turn, ?\\), do: {@west, next_turn}
  defp turn_cart(@east, next_turn, ?\\), do: {@south, next_turn}
  defp turn_cart(@south, next_turn, ?\\), do: {@east, next_turn}
  defp turn_cart(@west, next_turn, ?\\), do: {@north, next_turn}
  defp turn_cart(direction, next_turn, _), do: {direction, next_turn}

  def do_tick({carts, tracks}, crash_func) do
    _do_tick(
      {[], Enum.sort_by(carts, fn {position, _direction, _next_turn} -> position end)},
      tracks,
      crash_func
    )
  end

  defp _do_tick({:crash, position}, _tracks, _crash_func), do: {:crash, position}
  defp _do_tick({carts_moved, []}, tracks, _crash_func), do: {carts_moved, tracks}

  defp _do_tick({carts_moved, [cart | carts_to_move]}, tracks, crash_func) do
    {position, direction, next_turn} = cart

    new_position = move_cart(position, direction)

    new_carts =
      if Enum.any?(carts_moved ++ carts_to_move, &(elem(&1, 0) == new_position)) do
        crash_func.(new_position, carts_moved, carts_to_move)
      else
        {new_direction, new_next_turn} = turn_cart(direction, next_turn, tracks[new_position])

        {[{new_position, new_direction, new_next_turn} | carts_moved], carts_to_move}
      end

    _do_tick(new_carts, tracks, crash_func)
  end

  defp parse_tracks(raw_map) do
    raw_map
    |> Enum.map(fn
      {x, y, char} when char in [?>, ?<] -> {{x, y}, ?-}
      {x, y, char} when char in [?^, ?v] -> {{x, y}, ?|}
      {x, y, char} -> {{x, y}, char}
    end)
    |> Map.new()
  end

  defp parse_carts(raw_map) do
    raw_map
    |> Enum.filter(fn {_x, _y, char} -> char in [?<, ?^, ?>, ?v] end)
    |> Enum.map(fn {x, y, char} ->
      direction =
        case char do
          ?< -> @west
          ?^ -> @north
          ?> -> @east
          ?v -> @south
        end

      {{x, y}, direction, :left}
    end)
  end

  defp parse_input(input) do
    raw_map =
      input
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.to_charlist()
        |> Enum.with_index()
        |> Enum.reject(fn {char, _x} -> char == ?\s end)
        |> Enum.map(fn {char, x} -> {x, y, char} end)
      end)

    {parse_carts(raw_map), parse_tracks(raw_map)}
  end

  def solution1(input) do
    parse_input(input)
    |> Stream.iterate(&do_tick(&1, fn position, _, _ -> {:crash, position} end))
    |> Stream.drop_while(fn
      {:crash, _} -> false
      _ -> true
    end)
    |> Enum.at(0)
    |> then(fn {:crash, {x, y}} ->
      [x, y] |> Enum.join(",")
    end)
  end

  def solution2(input) do
    input
    |> parse_input()
    |> Stream.iterate(
      &do_tick(&1, fn position, moved, to_move ->
        {
          Enum.reject(moved, fn x -> elem(x, 0) == position end),
          Enum.reject(to_move, fn x -> elem(x, 0) == position end)
        }
      end)
    )
    |> Stream.drop_while(fn
      {[_cart], _tracks} -> false
      _ -> true
    end)
    |> Enum.at(0)
    |> then(fn {[{{x, y}, _direction, _next_turn}], _tracks} ->
      [x, y] |> Enum.join(",")
    end)
  end

  @doc """
  iex> Aoc2018.Day13.part1()
  "39,52"
  """
  def part1 do
    File.read!(@input_file)
    |> solution1()
  end

  @doc """
  iex> Aoc2018.Day13.part2()
  "133,146"
  """
  def part2 do
    File.read!(@input_file)
    |> solution2()
  end
end
