# Correct answer: 13337919186981

defmodule SignalArea do
  @search_range 0..4_000_000
  @frequency_coef 4_000_000

  def parse(lines) do
    Enum.map(lines, &parse_line/1)
  end

  def nonbeacons_range_at_row(data, row) do
    data
    |> Enum.map(&sensor_nonbeacons_range_at_row(&1, row))
    |> Enum.filter(&(&1.step == 1))
    |> Enum.reduce([], &merge_ranges/2)
  end

  def tuning_frequency(data) do
    @search_range
    |> Enum.map(&SignalArea.nonbeacons_range_at_row(data, &1))
    |> Enum.with_index()
    |> Enum.find(fn {ranges, _} ->
      Enum.any?(ranges, fn range ->
        @search_range.first < range.first || @search_range.last > range.last
      end)
    end)
    |> then(fn {ranges, y} ->
      x =
        ranges
        |> Enum.map(&[&1.first - 1, &1.last + 1])
        |> List.flatten()
        |> Enum.find(&(&1 in @search_range))

      x * @frequency_coef + y
    end)
    |> IO.inspect()
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
|> SignalArea.tuning_frequency()
