# Correct answer: 1142

defmodule Reader do
  @start_length 4

  def read_start(char, {chunk, index}) when is_list(chunk) and length(chunk) != @start_length do
    {:cont, {[char | chunk], index + 1}}
  end

  def read_start(char, {chunk, index}) when is_list(chunk) and length(chunk) == @start_length do
    chunk
    |> Enum.uniq()
    |> length
    |> case do
      @start_length -> {:halt, {chunk, index}}
      _ -> {:cont, {[char | Enum.drop(chunk, -1)], index + 1}}
    end
  end
end

File.read!("./inputs/06.txt")
|> String.to_charlist()
|> Enum.reduce_while({[], 0}, &Reader.read_start/2)
|> elem(1)
|> IO.inspect()
