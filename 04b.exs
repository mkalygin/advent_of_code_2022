File.stream!("./inputs/04.txt")
|> Stream.map(&String.trim_trailing/1)
|> Stream.map(fn pair ->
  [x1, x2, y1, y2] =
    pair
    |> String.split(",")
    |> Enum.map(&String.split(&1, "-"))
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)

  case Enum.sort([x1, x2, y1, y2]) do
    [^y1, ^x1, ^x2, ^y2] -> 1
    [^x1, ^y1, ^y2, ^x2] -> 1
    [^y1, ^x1, ^y2, ^x2] -> 1
    [^x1, ^y1, ^x2, ^y2] -> 1
    _ -> 0
  end
end)
|> Enum.to_list()
|> Enum.sum()
|> IO.inspect()
