defmodule RPS do
  @shapes %{
    "A" => :rock,
    "B" => :paper,
    "C" => :scissors,
    "X" => :rock,
    "Y" => :paper,
    "Z" => :scissors
  }

  @shape_values %{
    rock: 1,
    paper: 2,
    scissors: 3
  }

  @outcome_values %{
    loss: 0,
    draw: 3,
    win: 6
  }

  def score([code1, code2]) do
    shape1 = shape_from_code(code1)
    shape2 = shape_from_code(code2)
    outcome = play(shape2, shape1)

    shape_value(shape2) + outcome_value(outcome)
  end

  defp play(:rock, :scissors), do: :win
  defp play(:rock, :paper), do: :loss
  defp play(:paper, :rock), do: :win
  defp play(:paper, :scissors), do: :loss
  defp play(:scissors, :paper), do: :win
  defp play(:scissors, :rock), do: :loss
  defp play(shape1, shape2) when shape1 == shape2, do: :draw

  defp shape_from_code(shape_code), do: @shapes[shape_code]
  defp shape_value(shape), do: @shape_values[shape]
  defp outcome_value(outcome), do: @outcome_values[outcome]
end

File.stream!("./inputs/02.txt")
|> Stream.map(&String.trim_trailing/1)
|> Stream.map(&String.split/1)
|> Stream.map(&RPS.score/1)
|> Enum.to_list
|> Enum.sum
|> IO.inspect
