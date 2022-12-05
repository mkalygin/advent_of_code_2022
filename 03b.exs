# Correct answer: 2738

File.stream!("./inputs/03.txt")
|> Stream.map(&String.trim_trailing/1)
|> Stream.chunk_every(3)
|> Stream.map(fn rucksacks ->
  rucksacks
  |> Enum.map(&String.to_charlist/1)
  |> Enum.map(&MapSet.new/1)
  |> Enum.reduce(&MapSet.intersection/2)
  |> Enum.at(0)
  |> case do
    item when item in ?a..?z -> item - 96
    item when item in ?A..?Z -> item - 38
  end
end)
|> Enum.to_list()
|> Enum.sum()
|> IO.inspect()
