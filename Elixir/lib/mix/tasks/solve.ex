defmodule Mix.Tasks.Solve do
  @moduledoc false
  use Mix.Task

  def run(args) do
    args_parsed = OptionParser.parse(args, aliases: [p: :part], strict: [part: :integer])

    if args_parsed == {[], [], []} do
      Aoc2018.solve_all()
    else
      with {parts_parsed, [days_string], []} <- args_parsed,
           {day_number, ""} when day_number in 1..25 <- Integer.parse(days_string),
           {:ok, part} <- verify_part(parts_parsed) do
        Aoc2018.solve(day_number, part)
      else
        _ -> IO.puts("Invalid Arguments")
      end
    end
  end

  defp verify_part([]), do: {:ok, []}
  defp verify_part(part: part) when part in 1..2, do: {:ok, [part]}
  defp verify_part(_), do: :error
end
