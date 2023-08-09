defmodule Aoc2018 do
  @moduledoc """
  Documentation for `Aoc2018`.
  """
  require Mix.Generator

  @year 2018

  def solve_all() do
    1..25
    |> Enum.each(&solve/1)
  end

  def solve(day, parts \\ [1, 2])

  def solve(day, []), do: solve(day, [1, 2])

  def solve(day, parts) do
    run_day =
      day
      |> Integer.to_string()
      |> String.pad_leading(2, "0")

    module_day = Module.concat(__MODULE__, "Day#{run_day}")

    IO.puts("Solve Day #{day}")

    case Code.ensure_loaded(module_day) do
      {:module, _} ->
        parts
        |> Enum.each(fn part ->
          result = Function.capture(module_day, String.to_existing_atom("part#{part}"), 0).()

          IO.puts("Day #{day} part #{part} : #{result}")
        end)

      _ ->
        IO.puts("Day #{day} not defined")
    end

    IO.puts("---")
  end

  def gen(day) do
    gen_day = day |> Integer.to_string() |> String.pad_leading(2, "0")

    day_file = "lib/day#{gen_day}/day#{gen_day}.ex"
    day_test_file = "test/day#{gen_day}/day#{gen_day}_test.exs"
    input_file = "../inputs/day#{gen_day}.txt"

    assigns = [year: "#{@year}", day: gen_day]

    IO.puts("Generate day #{day} files")

    Mix.Generator.create_file(day_file, day_template(assigns))
    Mix.Generator.create_file(day_test_file, day_test_template(assigns))
    if File.exists?(input_file) == false, do: Mix.Generator.create_file(input_file, "")
  end

  Mix.Generator.embed_template(
    :day,
    """
    defmodule Aoc<%= @year %>.Day<%= @day %> do
      @moduledoc false

      @input_file "../inputs/day<%= @day %>.txt"

      defp parse_input(input) do
        input
      end

      def solution1(input) do
        input
        |> parse_input()
      end

      def solution2(input) do
        input
        |> parse_input()
      end

      # @doc \"""
      # iex> Aoc<%= @year %>.Day<%= @day %>.part1()
      # "part1"
      # \"""
      def part1 do
        File.read!(@input_file)
        |> solution1()
      end

      # @doc \"""
      # iex> Aoc<%= @year %>.Day<%= @day %>.part2()
      # "part2"
      # \"""
      def part2 do
        File.read!(@input_file)
        |> solution2()
      end
    end
    """
  )

  Mix.Generator.embed_template(:day_test, """
  defmodule Aoc<%= @year %>Test.Day<%= @day %>Test do
    @moduledoc false

    use ExUnit.Case
    import Aoc<%= @year %>.Day<%= @day %>

    doctest Aoc<%= @year %>.Day<%= @day %>

    # @test_input \"""
    # \"""

    test "Day<%= @day %> Test1" do
      # assert solution1(@test_input) == nil
    end

    test "Day<%= @day %> Test2" do
      # assert solution2(@test_input) == nil
    end
  end
  """)
end
