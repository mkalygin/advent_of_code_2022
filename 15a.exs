# Correct answer: 5256611

defmodule SignalArea do
  @default_search_row 2_000_000

  def parse(lines) do
    Enum.map(lines, &parse_line/1)
  end

  def nonbeacons_at_row(data, row \\ @default_search_row) do
    ranges =
      data
      |> Enum.map(&sensor_nonbeacons_range_at_row(&1, row))
      |> Enum.filter(&(&1.step == 1))
      |> Enum.reduce([], &merge_ranges/2)

    total =
      ranges
      |> Enum.reduce(0, &(&2 + Range.size(&1)))

    occupied =
      data
      |> Enum.map(&[&1.sensor, &1.beacon])
      |> List.flatten()
      |> Enum.filter(fn {x, y} ->
        y == row && Enum.any?(ranges, &(x in &1))
      end)
      |> Enum.uniq()
      |> Enum.count()

    total - occupied
  end

  defp parse_line(line) do
    ~r/-?\d+/
    |> Regex.scan(line)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.zip_with([:sensor, :beacon], &{&2, &1})
    |> Map.new()
  end

  defp sensor_nonbeacons_range_at_row(%{sensor: {sx, sy} = s, beacon: b}, row) do
    r = dist(s, b)
    dy = abs(sy - row)
    dx = r - dy

    (sx - dx)..(sx + dx)
  end

  defp merge_ranges(new_range, ranges) do
    ranges
    |> Enum.find_index(&(!Range.disjoint?(&1, new_range)))
    |> case do
      nil ->
        [new_range | ranges]

      index ->
        {range, ranges} = List.pop_at(ranges, index)
        new_range = min(range.first, new_range.first)..max(range.last, new_range.last)
        merge_ranges(new_range, ranges)
    end
  end

  defp dist({x1, y1}, {x2, y2}), do: abs(x2 - x1) + abs(y2 - y1)
end

File.stream!("./inputs/15.txt")
|> Stream.map(&String.trim_trailing/1)
|> Enum.to_list()
|> SignalArea.parse()
|> SignalArea.nonbeacons_at_row()
|> IO.inspect()
