defmodule Aoc2018.Day16 do
  @moduledoc false

  import Bitwise

  @input_file "../inputs/day16.txt"

  @opcodes_list [
    :addr,
    :addi,
    :mulr,
    :muli,
    :banr,
    :bani,
    :borr,
    :bori,
    :setr,
    :seti,
    :gtir,
    :gtri,
    :gtrr,
    :eqir,
    :eqri,
    :eqrr
  ]

  defp parse_input(input) do
    case String.split(input, "\n\n\n", trim: true) do
      [samples] -> {parse_samples(samples)}
      [samples, program] -> {parse_samples(samples), parse_program(program)}
    end
  end

  defp parse_samples(samples) do
    samples
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_bloc(&1))
  end

  defp parse_program(program) do
    program
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_instruction(&1))
  end

  defp parse_bloc(bloc) do
    [start, instruction, final] =
      bloc
      |> String.split("\n", trim: true)

    {parse_instruction(instruction), parse_register(start), parse_register(final)}
  end

  defp parse_register(register_string) do
    Regex.run(
      ~r/\[(\d+),\s(\d+),\s(\d+),\s(\d+)\]/,
      register_string
    )
    |> Enum.drop(1)
    |> Enum.with_index(&{&2, String.to_integer(&1)})
    |> Map.new()
  end

  defp parse_instruction(instruction) do
    instruction
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer(&1))
    |> List.to_tuple()
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

  defp process_sample(
         {{opcode_nb, a, b, c} = _instruction, start_register, final_register} = _sample,
         opcodes_list
       ) do
    opcodes_list
    |> Enum.map(&{opcode_nb, &1, exec({&1, a, b, c}, start_register) == final_register})
    |> Enum.filter(&elem(&1, 2))
  end

  defp find_opcode_table(samples) do
    Stream.iterate(%{}, fn opcode_table ->
      opcodes_to_find = Enum.reject(@opcodes_list, &(&1 in Map.values(opcode_table)))

      samples
      |> Enum.reject(fn
        {{opcode_nb, _a, _b, _c}, _start_register, _final_register} ->
          opcode_nb in Map.keys(opcode_table)
      end)
      |> Enum.map(&process_sample(&1, opcodes_to_find))
      |> Enum.filter(&(length(&1) == 1))
      |> Enum.dedup()
      |> Enum.map(&(&1 |> hd() |> Tuple.delete_at(2)))
      |> Map.new()
      |> Map.merge(opcode_table)
    end)
    |> Stream.drop_while(&(map_size(&1) < 16))
    |> Enum.at(0)
  end

  defp process_program(program, opcode_table) do
    start_register = Map.new(0..3, &{&1, 0})

    Enum.reduce(program, start_register, fn {opcode, a, b, c}, acc ->
      exec({opcode_table[opcode], a, b, c}, acc)
    end)
  end

  def solution1(input) do
    parse_input(input)
    |> elem(0)
    |> Enum.map(&process_sample(&1, @opcodes_list))
    |> Enum.count(&(length(&1) >= 3))
  end

  def solution2(input) do
    {samples, program} = parse_input(input)

    opcode_table = find_opcode_table(samples)

    program
    |> process_program(opcode_table)
    |> get_in([0])
  end

  @doc """
  iex> Aoc2018.Day16.part1()
  509
  """
  def part1 do
    File.read!(@input_file)
    |> solution1()
  end

  @doc """
  iex> Aoc2018.Day16.part2()
  496
  """
  def part2 do
    File.read!(@input_file)
    |> solution2()
  end
end
