# Correct answer: 8109

File.stream!("./inputs/03.txt")
|> Stream.map(&String.trim_trailing/1)
|> Stream.map(fn rucksack ->
  index = div(String.length(rucksack), 2)
  {left, right} = String.split_at(rucksack, index)

  left
  |> String.replace(~r/[^#{right}]/, "")
  |> String.to_charlist()
  |> hd
  |> case do
    item when item in ?a..?z -> item - 96
    item when item in ?A..?Z -> item - 38
  end
end)
|> Enum.to_list()
|> Enum.sum()
|> IO.inspect()
