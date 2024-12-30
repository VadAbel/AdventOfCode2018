defmodule Aoc2018.Day19 do
  @moduledoc false

  import Bitwise

  @input_file "../inputs/day19.txt"

  defp parse_input(input) do
    ["#ip " <> ip_register | program] = String.split(input, "\n", trim: true)

    program =
      program
      |> Enum.with_index(fn instruction, idx ->
        [opcode, i1, i2, o] = String.split(instruction, " ", trim: true)

        {idx,
         {String.to_atom(opcode), String.to_integer(i1), String.to_integer(i2),
          String.to_integer(o)}}
      end)
      |> Map.new()

    register =
      Map.new(0..5, &{&1, 0})
      |> Map.put(:ip, String.to_integer(ip_register))

    {register, program}
  end

  defp exec({:addr, a, b, c}, register),
    do: put_in(register[c], register[a] + register[b])

  defp exec({:addi, a, b, c}, register),
    do: put_in(register[c], register[a] + b)

  defp exec({:mulr, a, b, c}, register),
    do: put_in(register[c], register[a] * register[b])

  defp exec({:muli, a, b, c}, register),
    do: put_in(register[c], register[a] * b)

  defp exec({:banr, a, b, c}, register),
    do: put_in(register[c], band(register[a], register[b]))

  defp exec({:bani, a, b, c}, register),
    do: put_in(register[c], band(register[a], b))

  defp exec({:borr, a, b, c}, register),
    do: put_in(register[c], bor(register[a], register[b]))

  defp exec({:bori, a, b, c}, register),
    do: put_in(register[c], bor(register[a], b))

  defp exec({:setr, a, _input2, c}, register),
    do: put_in(register[c], register[a])

  defp exec({:seti, a, _input2, c}, register),
    do: put_in(register[c], a)

  defp exec({:gtir, a, b, c}, register),
    do:
      if(a > register[b],
        do: put_in(register[c], 1),
        else: put_in(register[c], 0)
      )

  defp exec({:gtri, a, b, c}, register),
    do:
      if(register[a] > b,
        do: put_in(register[c], 1),
        else: put_in(register[c], 0)
      )

  defp exec({:gtrr, a, b, c}, register),
    do:
      if(register[a] > register[b],
        do: put_in(register[c], 1),
        else: put_in(register[c], 0)
      )

  defp exec({:eqir, a, b, c}, register),
    do:
      if(a == register[b],
        do: put_in(register[c], 1),
        else: put_in(register[c], 0)
      )

  defp exec({:eqri, a, b, c}, register),
    do:
      if(register[a] == b,
        do: put_in(register[c], 1),
        else: put_in(register[c], 0)
      )

  defp exec({:eqrr, a, b, c}, register),
    do:
      if(register[a] == register[b],
        do: put_in(register[c], 1),
        else: put_in(register[c], 0)
      )

  defp get_instruction(program, register), do: program[register[register.ip]]

  defp increment_ip(register), do: Map.update!(register, register.ip, &(&1 + 1))
  defp decrement_ip(register), do: Map.update!(register, register.ip, &(&1 - 1))

  def solution1(input) do
    {register, program} = parse_input(input)

    register
    |> Stream.iterate(
      &(exec(get_instruction(program, &1), &1)
        |> increment_ip())
    )
    |> Stream.drop_while(&Map.has_key?(program, &1[&1.ip]))
    |> Enum.at(0)
    |> decrement_ip()
    |> Map.get(0)
  end

  def solution2(input) do
    {register, program} = parse_input(input)

    register
    |> Map.put(0, 1)
    |> Stream.iterate(
      # itercept la boucle du program (recherche des diviseur de register[4])
      &if &1[&1.ip] == 1 do
        val =
          1..&1[4]
          |> Stream.filter(fn a -> rem(&1[4], a) == 0 end)
          |> Enum.sum()

        &1
        |> Map.put(0, val)
        |> Map.put(&1.ip, 16 * 16)
      else
        exec(get_instruction(program, &1), &1)
        |> increment_ip()
      end
    )
    |> Stream.drop_while(&Map.has_key?(program, &1[&1.ip]))
    |> Enum.at(0)
    |> decrement_ip()
    |> Map.get(0)
  end

  @doc """
  iex> Aoc2018.Day19.part1()
  1728
  """
  def part1 do
    File.read!(@input_file)
    |> solution1()
  end

  @doc """
  iex> Aoc2018.Day19.part2()
  18200448
  """
  def part2 do
    File.read!(@input_file)
    |> solution2()
  end
end
