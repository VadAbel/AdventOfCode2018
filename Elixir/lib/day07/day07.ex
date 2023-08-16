defmodule Aoc2018.Day07 do
  @moduledoc false

  @input_file "../inputs/day07.txt"

  defp process_step_workers(
         _finish_steps,
         [],
         _steps,
         [],
         time,
         _fix_time_step,
         _max_workers
       ) do
    time
  end

  defp process_step_workers(
         finish_steps,
         possible_steps,
         steps,
         workers,
         time,
         fix_time_step,
         max_workers
       )
       when length(workers) == max_workers or possible_steps == [] do
    process_workers(
      finish_steps,
      possible_steps,
      steps,
      workers,
      time,
      fix_time_step,
      max_workers
    )
  end

  defp process_step_workers(
         finish_steps,
         [next_step | rest_steps],
         steps,
         workers,
         time,
         fix_time_step,
         max_workers
       )
       when length(workers) < max_workers do
    new_workers = [{next_step, fix_time_step + next_step - ?A + 1} | workers]

    process_step_workers(
      finish_steps,
      rest_steps,
      steps,
      new_workers,
      time,
      fix_time_step,
      max_workers
    )
  end

  defp process_workers(
         finish_steps,
         possible_steps,
         steps,
         workers,
         time,
         fix_time_step,
         max_workers
       ) do
    {finish_workers, running_workers} =
      workers
      |> Enum.map(fn {step, remain_time} -> {step, remain_time - 1} end)
      |> Enum.split_with(fn {_step, remain_time} -> remain_time == 0 end)

    new_finish_steps =
      Enum.reduce(finish_workers, finish_steps, fn {step, _}, acc -> [step | acc] end)

    new_possible_steps =
      MapSet.new(possible_steps)
      |> MapSet.union(
        finish_workers
        |> Enum.reduce(MapSet.new(), fn {finish_step, _}, acc ->
          MapSet.union(steps[finish_step][:next_step], acc)
        end)
        |> MapSet.filter(fn k -> steps[k][:need_step] |> Enum.all?(&(&1 in new_finish_steps)) end)
      )
      |> Enum.sort()

    process_step_workers(
      new_finish_steps,
      new_possible_steps,
      steps,
      running_workers,
      time + 1,
      fix_time_step,
      max_workers
    )
  end

  defp process_step(finish_steps, [], _steps) do
    Enum.reverse(finish_steps)
  end

  defp process_step(finish_steps, [next_step | rest_steps], steps) do
    new_finish_steps = [next_step | finish_steps]

    possible_steps =
      MapSet.new(rest_steps)
      |> MapSet.union(
        steps[next_step][:next_step]
        |> MapSet.filter(fn k -> steps[k][:need_step] |> Enum.all?(&(&1 in new_finish_steps)) end)
      )
      |> Enum.sort()

    process_step(new_finish_steps, possible_steps, steps)
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn <<"Step ", a, " must be finished before step ", b, " can begin.">> ->
      {a, b}
    end)
    |> Enum.reduce(%{}, fn {x, y}, acc ->
      acc
      |> update_in(
        [Access.key(x, %{next_step: MapSet.new(), need_step: MapSet.new()}), :next_step],
        &MapSet.put(&1, y)
      )
      |> update_in(
        [Access.key(y, %{next_step: MapSet.new(), need_step: MapSet.new()}), :need_step],
        &MapSet.put(&1, x)
      )
    end)
  end

  def solution1(input) do
    steps = parse_input(input)

    first_steps =
      steps
      |> Map.filter(fn {_k, %{need_step: value}} -> value == MapSet.new() end)
      |> Map.keys()
      |> Enum.sort()

    process_step([], first_steps, steps)
    |> List.to_string()
  end

  def solution2(input, fix_time_step \\ 60, max_workers \\ 5) do
    steps = parse_input(input)

    first_steps =
      steps
      |> Map.filter(fn {_k, %{need_step: value}} -> value == MapSet.new() end)
      |> Map.keys()
      |> Enum.sort()

    process_step_workers([], first_steps, steps, [], 0, fix_time_step, max_workers)
  end

  @doc """
  iex> Aoc2018.Day07.part1()
  "GLMVWXZDKOUCEJRHFAPITSBQNY"
  """
  def part1 do
    File.read!(@input_file)
    |> solution1()
  end

  @doc """
  iex> Aoc2018.Day07.part2()
  1105
  """
  def part2 do
    File.read!(@input_file)
    |> solution2()
  end
end
