# Correct answer: 2803

defmodule Reader do
  @message_length 14

  def read_message(char, {chunk, index})
      when is_list(chunk) and length(chunk) != @message_length do
    {:cont, {[char | chunk], index + 1}}
  end

  def read_message(char, {chunk, index})
      when is_list(chunk) and length(chunk) == @message_length do
    chunk
    |> Enum.uniq()
    |> length
    |> case do
      @message_length -> {:halt, {chunk, index}}
      _ -> {:cont, {[char | Enum.drop(chunk, -1)], index + 1}}
    end
  end
end

File.read!("./inputs/06.txt")
|> String.to_charlist()
|> Enum.reduce_while({[], 0}, &Reader.read_message/2)
|> elem(1)
|> IO.inspect()
