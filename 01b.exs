File.stream!("./inputs/01.txt")
|> Stream.map(&String.trim_trailing/1)
|> Stream.chunk_by(&(&1 !== ""))
|> Stream.filter(&(hd(&1) !== ""))
|> Stream.map(fn calories ->
  calories
  |> Enum.map(&String.to_integer/1)
  |> Enum.sum()
end)
|> Enum.to_list()
|> Enum.sort(&(&1 >= &2))
|> Enum.take(3)
|> Enum.sum
|> IO.inspect()
