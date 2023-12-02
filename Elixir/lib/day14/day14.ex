defmodule Aoc2018.Day14 do
  @moduledoc false

  @input_file "../inputs/day14.txt"

  @scores_start <<3, 7>>
  @elfs_start [0, 1]

  defp parse_input(input) do
    String.to_integer(input)
  end

  def solution1(input) do
    time = parse_input(input)

    Stream.iterate({@elfs_start, @scores_start}, fn {elfs, scores} ->
      recipes =
        elfs
        |> Enum.map(&:binary.at(scores, &1))
        |> Enum.sum()
        |> Integer.digits()

      new_scores = scores <> :binary.list_to_bin(recipes)

      scores_length = byte_size(new_scores)

      new_elfs =
        elfs
        |> Enum.map(fn pos ->
          rem(
            pos + 1 + :binary.at(new_scores, pos),
            scores_length
          )
        end)

      {new_elfs, new_scores}
    end)
    |> Stream.drop_while(fn {_elfs, scores} ->
      byte_size(scores) < time + 10
    end)
    |> Enum.at(0)
    |> elem(1)
    |> :binary.bin_to_list(time, 10)
    |> Enum.join()
  end

  def solution2(input) do
    pattern =
      input
      |> String.to_charlist()
      |> Enum.map(&(&1 - ?0))

    Stream.unfold({@elfs_start, @scores_start, @scores_start |> :binary.bin_to_list()}, fn
      {elfs, scores, []} ->
        recipes =
          elfs
          |> Enum.map(&:binary.at(scores, &1))
          |> Enum.sum()
          |> Integer.digits()

        new_scores = scores <> :binary.list_to_bin(recipes)

        scores_length = byte_size(new_scores)

        new_elfs =
          elfs
          |> Enum.map(fn pos ->
            rem(
              pos + 1 + :binary.at(new_scores, pos),
              scores_length
            )
          end)

        {hd(recipes), {new_elfs, new_scores, tl(recipes)}}

      {elfs, scores, [h | t]} ->
        {h, {elfs, scores, t}}
    end)
    |> Stream.chunk_every(length(pattern), 1)
    |> Stream.with_index()
    |> Stream.drop_while(&(elem(&1, 0) != pattern))
    |> Enum.at(0)
    |> elem(1)
    |> Integer.to_string()
  end

  @doc """
  iex> Aoc2018.Day14.part1()
  "5992684592"
  """
  def part1 do
    File.read!(@input_file)
    |> solution1()
  end

  @doc """
  iex> Aoc2018.Day14.part2()
  "20181148"
  """
  def part2 do
    File.read!(@input_file)
    |> solution2()
  end
end
