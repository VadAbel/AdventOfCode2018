defmodule Aoc2018.Day04 do
  @moduledoc false

  @input_file "../inputs/day04.txt"

  defp update_sleep_map(sleep_map, guard, from_minute, to_minute) do
    from_minute..(to_minute - 1)//1
    |> Enum.reduce(
      sleep_map,
      fn minute, acc ->
        update_in(acc, [Access.key(guard, %{}), Access.key(minute, 0)], &(&1 + 1))
      end
    )
  end

  defp process_actions(
         actions,
         sleep_map \\ %{},
         guard \\ nil,
         state \\ nil,
         prev_minute \\ nil
       )

  defp process_actions([], sleep_map, guard, :asleep, prev_minute) do
    update_sleep_map(sleep_map, guard, prev_minute, 60)
  end

  defp process_actions([], sleep_map, _guard, _state, _prev_minute) do
    sleep_map
  end

  defp process_actions(
         [%{action: {:guard, new_guard}} | rest],
         sleep_map,
         guard,
         :asleep,
         prev_minute
       ) do
    process_actions(
      rest,
      update_sleep_map(sleep_map, guard, prev_minute, 60),
      new_guard,
      :awake,
      0
    )
  end

  defp process_actions(
         [%{action: {:guard, new_guard}} | rest],
         sleep_map,
         _guard,
         _state,
         _prev_minute
       ) do
    process_actions(rest, sleep_map, new_guard, :awake, 0)
  end

  defp process_actions(
         [%{minute: action_minute, action: :awake} | rest],
         sleep_map,
         guard,
         _state,
         prev_minute
       ) do
    process_actions(
      rest,
      update_sleep_map(sleep_map, guard, prev_minute, action_minute),
      guard,
      :awake,
      action_minute
    )
  end

  defp process_actions(
         [%{minute: action_minute, action: :asleep} | rest],
         sleep_map,
         guard,
         _state,
         _prev_minute
       ) do
    process_actions(
      rest,
      sleep_map,
      guard,
      :asleep,
      action_minute
    )
  end

  defp format_guard_sleep(sleep_map) do
    Enum.map(
      sleep_map,
      fn {guard, minute_map} ->
        {
          guard,
          Enum.max_by(minute_map, &elem(&1, 1), fn -> :error end),
          Enum.sum(Map.values(minute_map))
        }
      end
    )
  end

  defp calcul_output({guard, {minute, _}, _}), do: guard * minute

  defp parse_action("Guard #" <> <<guard::binary>>), do: {:guard, String.to_integer(guard)}
  defp parse_action("falls asleep"), do: :asleep
  defp parse_action("wakes up"), do: :awake

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.sort()
    |> Enum.map(fn record ->
      parsed_record =
        Regex.named_captures(
          ~r/\[\d{4}-\d{2}-\d{2} \d{2}:(?<minute>\d{2})] (?<action>Guard #\d+|falls asleep|wakes up).*/,
          record
        )

      %{
        minute: String.to_integer(parsed_record["minute"]),
        action: parse_action(parsed_record["action"])
      }
    end)
  end

  def solution1(input) do
    input
    |> parse_input()
    |> process_actions()
    |> format_guard_sleep()
    |> Enum.max_by(&elem(&1, 2))
    |> calcul_output()

    # manque le cas ou le dernier shift dort a la fin
  end

  def solution2(input) do
    input
    |> parse_input()
    |> process_actions()
    |> format_guard_sleep()
    |> Enum.max_by(&elem(elem(&1, 1), 1))
    |> calcul_output()
  end

  @doc """
  iex> Aoc2018.Day04.part1()
  14346
  """
  def part1 do
    File.read!(@input_file)
    |> solution1()
  end

  @doc """
  iex> Aoc2018.Day04.part2()
  5705
  """
  def part2 do
    File.read!(@input_file)
    |> solution2()
  end
end
