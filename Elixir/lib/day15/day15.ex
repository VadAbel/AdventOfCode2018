defmodule Aoc2018.Day15 do
  @moduledoc false

  @input_file "../inputs/day15.txt"

  @wall ?#
  @open ?.
  @goblin ?G
  @elf ?E

  @start_hitpoints 200
  @power 3

  defp parse_input(input) do
    b =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.to_charlist()
        |> Enum.with_index(fn char, x -> {{y, x}, char} end)
      end)

    {parse_board(b), parse_units(b)}
  end

  def parse_board(b) do
    b
    |> Enum.reduce(
      %{wall: MapSet.new(), open: MapSet.new()},
      fn {pos, cell}, board ->
        case cell do
          @wall -> update_in(board.wall, &MapSet.put(&1, pos))
          c when c in [@elf, @goblin, @open] -> update_in(board.open, &MapSet.put(&1, pos))
        end
      end
    )
  end

  def parse_units(b) do
    b
    |> Enum.reduce([], fn {pos, cell}, units ->
      case cell do
        @elf -> [%{kind: :elf, health: @start_hitpoints, pos: pos} | units]
        @goblin -> [%{kind: :goblin, health: @start_hitpoints, pos: pos} | units]
        _ -> units
      end
    end)
    |> Enum.with_index(fn x, idx -> {idx, x} end)
    |> Map.new()
  end

  def get_units_order(units) do
    units
    |> Enum.sort_by(fn {_, u} -> u.pos end)
    |> Enum.map(&elem(&1, 0))
  end

  def get_adjacents_cells({y_pos, x_pos}, board) do
    [{-1, 0}, {0, -1}, {1, 0}, {0, 1}]
    |> Enum.map(fn {y, x} -> {y + y_pos, x + x_pos} end)
    |> MapSet.new()
    |> MapSet.difference(board.wall)
  end

  def alive?(unit), do: unit.health > 0

  def target_kind(kind)
  def target_kind(:elf), do: :goblin
  def target_kind(:goblin), do: :elf

  def targets_in_range(u_id, units, board) do
    targets_id =
      units
      |> Map.filter(fn {_key, value} ->
        alive?(value) &&
          value.kind == target_kind(units[u_id].kind) &&
          value.pos in get_adjacents_cells(units[u_id].pos, board)
      end)
      |> Map.keys()

    case targets_id do
      [] -> {:no_targets}
      _ -> {:ok, targets_id}
    end
  end

  def occupied_cell?(pos, units) do
    units
    |> Map.values()
    |> get_in([Access.filter(&alive?(&1)), :pos])
    |> Enum.member?(pos)
  end

  def count_elf(units) do
    units
    |> Map.values()
    |> Enum.count(&(&1.kind == :elf))
  end

  def add_power(units, {elf_power, goblin_power}) do
    units
    |> Map.keys()
    |> Enum.reduce(units, fn u_id, acc ->
      case units[u_id].kind do
        :elf -> put_in(acc, [u_id, :power], elf_power)
        :goblin -> put_in(acc, [u_id, :power], goblin_power)
      end
    end)
  end

  def expand_path({path, visited}, units, board) do
    [last_cell | _rest_cells] = path

    get_adjacents_cells(last_cell, board)
    |> Enum.reject(&(occupied_cell?(&1, units) || MapSet.member?(visited, &1)))
    |> Enum.map(&{[&1 | path], MapSet.put(visited, &1)})
  end

  def merge_paths(paths) do
    paths
    |> Enum.group_by(fn {[last_cell | _] = _path, _visited} -> last_cell end)
    |> Map.values()
    |> Enum.map(fn l ->
      {paths_list, visited_list} = Enum.unzip(l)

      {
        paths_list
        |> Enum.sort()
        |> List.first(),
        visited_list
        |> Enum.reduce(&MapSet.union(&1, &2))
      }
    end)
  end

  def find_short_path_to_target(u_id, units, board) do
    targets_cells =
      units
      |> Map.values()
      |> get_in([Access.filter(&(&1.kind == target_kind(units[u_id].kind) && alive?(&1))), :pos])
      |> Enum.flat_map(&get_adjacents_cells(&1, board))
      |> Enum.dedup()
      |> Enum.reject(&occupied_cell?(&1, units))

    [{[units[u_id].pos], MapSet.new([units[u_id].pos])}]
    |> Stream.iterate(fn paths ->
      paths
      |> Enum.flat_map(&expand_path(&1, units, board))
      |> merge_paths()
    end)
    |> Stream.map(fn
      [] ->
        {:no_paths}

      paths ->
        case Enum.filter(paths, &(List.first(elem(&1, 0)) in targets_cells)) do
          [] ->
            {:cont}

          p ->
            {
              :found,
              p
              |> Enum.map(&elem(&1, 0))
              |> Enum.sort_by(&Enum.reverse_slice(&1, 1, length(&1) - 1))
              |> List.first()
            }
        end
    end)
    |> Stream.drop_while(&(&1 == {:cont}))
    |> Enum.at(0)
  end

  def unit_move_phase(units, u_id, board) do
    with {:no_targets} <- targets_in_range(u_id, units, board),
         {:found, path} <- find_short_path_to_target(u_id, units, board) do
      put_in(units, [u_id, :pos], Enum.at(path, -2))
    else
      _ -> units
    end
  end

  def unit_attack_phase(units, u_id, board) do
    case targets_in_range(u_id, units, board) do
      {:ok, targets_id} ->
        target_id =
          units
          |> Map.filter(fn {k, v} -> k in targets_id && alive?(v) end)
          |> Enum.sort_by(fn {_k, v} -> {v.health, v.pos} end)
          |> List.first()
          |> elem(0)

        update_in(units, [target_id, :health], &(&1 - units[u_id].power))

      _ ->
        units
    end
  end

  def finish?(units) do
    units
    |> Map.values()
    |> Enum.dedup_by(& &1.kind)
    |> length() == 1
  end

  def do_unit_turn(u_id, units, _board) when not is_map_key(units, u_id), do: units

  def do_unit_turn(u_id, units, board) do
    if finish?(units) do
      {:finished, units}
    else
      units
      |> unit_move_phase(u_id, board)
      |> unit_attack_phase(u_id, board)
      |> Map.filter(fn {_k, v} -> alive?(v) end)
    end
  end

  def do_round(units, board) do
    units
    |> get_units_order()
    |> Enum.reduce_while(units, fn u_id, units ->
      case do_unit_turn(u_id, units, board) do
        {:finished, new_units} -> {:halt, {:finished, new_units}}
        new_units -> {:cont, new_units}
      end
    end)
  end

  def do_game(units, board, {_elf_power, _goblin_power} = powers) do
    units
    |> add_power(powers)
    |> Stream.iterate(&do_round(&1, board))
    |> Stream.with_index()
    |> Stream.drop_while(fn
      {{:finished, _units}, _turn} -> false
      _ -> true
    end)
    |> Enum.at(0)
  end

  def solution1(input) do
    {board, units} = parse_input(input)

    units
    |> do_game(board, {@power, @power})
    |> then(fn {{:finished, units}, turn} ->
      (units
       |> Map.values()
       |> Enum.map(& &1.health)
       |> Enum.sum()) * (turn - 1)
    end)
  end

  def solution2(input) do
    {board, units} = parse_input(input)

    Stream.iterate(4, &(&1 + 1))
    |> Stream.map(fn elf_power ->
      {{:finished, final_units}, turn} = do_game(units, board, {elf_power, @power})

      {final_units, turn, count_elf(units), count_elf(final_units)}
    end)
    |> Stream.drop_while(fn {_units, _turn, start_elf, final_elf} -> start_elf != final_elf end)
    |> Enum.at(0)
    |> then(fn {units, turn, _start_elf, _final_elf} ->
      (units
       |> Map.values()
       |> Enum.map(& &1.health)
       |> Enum.sum()) * (turn - 1)
    end)
  end

  @doc """
  iex> Aoc2018.Day15.part1()
  218272
  """
  def part1 do
    File.read!(@input_file)
    |> solution1()
  end

  @doc """
  iex> Aoc2018.Day15.part2()
  40861
  """
  def part2 do
    File.read!(@input_file)
    |> solution2()
  end
end
