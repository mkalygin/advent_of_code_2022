# Correct answer: VQZNJMWTR

[state, instructions] =
  File.stream!("./inputs/05.txt")
  |> Stream.chunk_by(&(&1 !== "\n"))
  |> Stream.filter(&(hd(&1) !== "\n"))
  |> Enum.to_list()

keys =
  state
  |> List.last()
  |> String.split(~r/\s+/, trim: true)
  |> Enum.map(&String.to_integer/1)

stacks =
  state
  |> Enum.reverse()
  |> Enum.drop(1)
  |> Enum.map(fn line ->
    line
    |> String.split(~r/.{4}/, include_captures: true, trim: true)
    |> Enum.map(&Regex.replace(~r/[^\w]/, &1, ""))
  end)
  |> Enum.reduce(Map.new(keys, &{&1, []}), fn line, acc ->
    List.zip([keys, line])
    |> Enum.filter(fn {_k, v} -> v != "" end)
    |> Map.new()
    |> Map.merge(acc, fn _k, v1, v2 -> [v1 | v2] end)
  end)

instructions
|> Enum.reduce(stacks, fn instruction, acc ->
  [count, from, to] =
    Regex.split(~r/[^\d]/, instruction, trim: true)
    |> Enum.map(&String.to_integer/1)

  moved =
    acc[from]
    |> Enum.take(count)
    |> Enum.reverse()

  acc
  |> Map.put(to, moved ++ acc[to])
  |> Map.put(from, Enum.drop(acc[from], count))
end)
|> Map.values()
|> Enum.map(&hd/1)
|> Enum.join()
|> IO.inspect()
