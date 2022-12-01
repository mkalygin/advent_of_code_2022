File.stream!("./inputs/01.txt")
|> Stream.map(&String.trim_trailing/1)
|> Stream.chunk_by(&(&1 !== ""))
|> Stream.filter(&(hd(&1) !== ""))
|> Stream.map(fn callories ->
  callories
  |> Enum.map(&String.to_integer/1)
  |> Enum.sum()
end)
|> Enum.to_list()
|> Enum.max()
|> IO.inspect()
