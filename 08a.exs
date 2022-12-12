# Correct answer: 1688

defmodule Forest do
  @min_height -1

  def visible_trees_count(forest) do
    forest
    |> Tuple.to_list()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {trees, i}, acc_i ->
      trees
      |> Tuple.to_list()
      |> Enum.with_index()
      |> Enum.reduce(acc_i, fn {_, j}, acc_j ->
        if visible_tree_at?(forest, {i, j}), do: acc_j + 1, else: acc_j
      end)
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

  defp visible_tree_at?(forest, {i, j}) do
    visible_tree_in_direction?(forest, {i, j}, {i + 1, j}) ||
      visible_tree_in_direction?(forest, {i, j}, {i - 1, j}) ||
      visible_tree_in_direction?(forest, {i, j}, {i, j + 1}) ||
      visible_tree_in_direction?(forest, {i, j}, {i, j - 1})
  end

  defp visible_tree_in_direction?(forest, {i, j}, {ni, nj}) do
    tree = tree_at(forest, {i, j})
    next_tree = tree_at(forest, {ni, nj})
    {di, dj} = {min(max(ni - i, -1), 1), min(max(nj - j, -1), 1)}

    case next_tree do
      @min_height ->
        true

      _ ->
        tree > next_tree && visible_tree_in_direction?(forest, {i, j}, {ni + di, nj + dj})
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
|> Forest.visible_trees_count()
|> IO.inspect()
