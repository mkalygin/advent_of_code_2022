defmodule RPS do
  @shapes %{
    "A" => :rock,
    "B" => :paper,
    "C" => :scissors,
    "X" => :rock,
    "Y" => :paper,
    "Z" => :scissors
  }

  @outcomes %{
    "X" => :loss,
    "Y" => :draw,
    "Z" => :win
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

  def score([shape_code, outcome_code]) do
    shape1 = shape_from_code(shape_code)
    outcome = outcome_from_code(outcome_code)
    shape2 = shape_for_outcome(outcome, shape1)

    shape_value(shape2) + outcome_value(outcome)
  end

  defp shape_for_outcome(:win, :rock), do: :paper
  defp shape_for_outcome(:loss, :rock), do: :scissors
  defp shape_for_outcome(:win, :paper), do: :scissors
  defp shape_for_outcome(:loss, :paper), do: :rock
  defp shape_for_outcome(:win, :scissors), do: :rock
  defp shape_for_outcome(:loss, :scissors), do: :paper
  defp shape_for_outcome(:draw, shape), do: shape

  defp shape_from_code(shape_code), do: @shapes[shape_code]
  defp outcome_from_code(outcome_code), do: @outcomes[outcome_code]
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
