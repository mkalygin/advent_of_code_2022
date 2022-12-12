# Correct answer: 410400

defmodule Forest do
  @min_height -1

  def scenic_scores(forest) do
    forest
    |> Tuple.to_list()
    |> Enum.with_index()
    |> Enum.map(fn {trees, i} ->
      trees
      |> Tuple.to_list()
      |> Enum.with_index()
      |> Enum.map(&scenic_score_at(forest, {i, elem(&1, 1)}))
    end)
  end

  defp tree_at(forest, {i, j}) do
    try do
      forest
      |> elem(i)
      |> elem(j)
    rescue
      _ -> @min_height
    end
  end

  defp scenic_score_at(forest, {i, j}) do
    scenic_score_in_direction(forest, {i, j}, {i + 1, j}) *
      scenic_score_in_direction(forest, {i, j}, {i - 1, j}) *
      scenic_score_in_direction(forest, {i, j}, {i, j + 1}) *
      scenic_score_in_direction(forest, {i, j}, {i, j - 1})
  end

  defp scenic_score_in_direction(forest, {i, j}, {ni, nj}) do
    tree = tree_at(forest, {i, j})
    next_tree = tree_at(forest, {ni, nj})
    {di, dj} = {min(max(ni - i, -1), 1), min(max(nj - j, -1), 1)}

    cond do
      next_tree == @min_height ->
        0

      next_tree >= tree ->
        1

      tree > next_tree ->
        1 + scenic_score_in_direction(forest, {i, j}, {ni + di, nj + dj})
    end
  end
end

File.stream!("./inputs/08.txt")
|> Stream.map(&String.trim_trailing/1)
|> Enum.to_list()
|> Enum.map(fn line ->
  line
  |> String.split("", trim: true)
  |> Enum.map(&String.to_integer/1)
  |> List.to_tuple()
end)
|> List.to_tuple()
|> Forest.scenic_scores()
|> List.flatten()
|> Enum.max()
|> IO.inspect()
