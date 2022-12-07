# Correct answer: 3636703

defmodule Terminal do
  def interpret(<<"$ ls">>, state), do: state
  def interpret(<<"dir ", _dir::binary>>, state), do: state

  def interpret(<<"$ cd ", path::binary>>, {tree, cwd}) do
    cwd = Path.expand(path, cwd)
    tree = Map.put_new(tree, cwd, 0)
    {tree, cwd}
  end

  def interpret(output, {tree, cwd}) do
    [size, _file] = String.split(output, " ")
    tree = inc_dir_size(tree, cwd, String.to_integer(size))
    {tree, cwd}
  end

  defp inc_dir_size(tree, dir, size) do
    tree = Map.put(tree, dir, tree[dir] + size)

    case dir do
      "/" -> tree
      _ -> inc_dir_size(tree, Path.dirname(dir), size)
    end
  end
end

{tree, _} =
  File.stream!("./inputs/07.txt")
  |> Stream.map(&String.trim_trailing/1)
  |> Enum.to_list()
  |> Enum.reduce({%{}, ""}, &Terminal.interpret/2)

total_space = 70_000_000
free_space = total_space - tree["/"]
required_space = 30_000_000 - free_space

tree
|> Map.values()
|> Enum.filter(&(&1 >= required_space))
|> Enum.sort()
|> hd()
|> IO.inspect()
