defmodule Mix.Tasks.Gen do
  @moduledoc false
  use Mix.Task

  def run(args) do
    with {[], [day_string], []} <- OptionParser.parse(args, strict: []),
         {day, ""} when day in 1..25 <- Integer.parse(day_string) do
      Aoc2018.gen(day)
    else
      _ -> IO.puts("Invalid Arguments")
    end
  end
end
