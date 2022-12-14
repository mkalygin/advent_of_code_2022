# Correct answer: 28594

defmodule Cave do
  @sand_source {500, 0}
  @floor_depth 2

  def parse(lines) do
    lines
    |> Enum.map(&parse_line/1)
    |> Enum.map(&init_rocks/1)
    |> List.flatten()
    |> Map.new()
  end

  def simulate(cave) do
    do_simulation(cave, depth(cave) + @floor_depth, @sand_source)
  end

  def sand_count(cave) do
    cave
    |> Map.values()
    |> Enum.filter(&(&1 == :sand))
    |> length()
  end

  defp parse_line(line) do
    line
    |> String.split(" -> ")
    |> Enum.map(fn coords ->
      coords
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  defp init_rocks(points) do
    points
    |> Enum.reduce({[], nil}, fn point, {rocks, prev_point} ->
      case prev_point do
        nil -> {[{point, :rock} | rocks], point}
        _ -> {rocks_range(prev_point, point) ++ rocks, point}
      end
    end)
    |> elem(0)
  end

  defp rocks_range({x1, y1}, {x2, y2}) when x1 == x2, do: Enum.map(y1..y2, &{{x1, &1}, :rock})
  defp rocks_range({x1, y1}, {x2, y2}) when y1 == y2, do: Enum.map(x1..x2, &{{&1, y1}, :rock})

  defp depth(cave) do
    cave
    |> Map.keys()
    |> Enum.map(&elem(&1, 1))
    |> Enum.max()
  end

  defp do_simulation(cave, _floor, @sand_source) when is_map_key(cave, @sand_source), do: cave

  defp do_simulation(cave, floor, {x, y}) do
    cond do
      not is_map_key(cave, {x, y + 1}) and y + 1 < floor ->
        do_simulation(cave, floor, {x, y + 1})

      not is_map_key(cave, {x - 1, y + 1}) and y + 1 < floor ->
        do_simulation(cave, floor, {x - 1, y + 1})

      not is_map_key(cave, {x + 1, y + 1}) and y + 1 < floor ->
        do_simulation(cave, floor, {x + 1, y + 1})

      true ->
        cave
        |> Map.put({x, y}, :sand)
        |> do_simulation(floor, @sand_source)
    end
  end
end

File.stream!("./inputs/14.txt")
|> Stream.map(&String.trim_trailing/1)
|> Enum.to_list()
|> Cave.parse()
|> Cave.simulate()
|> Cave.sand_count()
|> IO.inspect()
