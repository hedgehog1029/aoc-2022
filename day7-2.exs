defmodule AOC.Day do
  def parse_ls([], state) do
    {state, []}
  end

  def parse_ls([line | tail], state) when binary_part(line, 0, 1) == "$" do
    {state, [line | tail]}
  end

  def parse_ls([line | tail], children) do
    [size, name] = String.split(line, " ")
    if size == "dir" do
      parse_ls(tail, Map.put(children, name, {:dir, name, %{}}))
    else
      parse_ls(tail, Map.put(children, name, {:file, name, String.to_integer(size)}))
    end
  end

  def parse_command([], children) do
    {children, []}
  end

  def parse_command([line | tail], children) do
    [_dollar, cmd | args] = String.split(line, " ")

    case cmd do
      "cd" ->
        [path] = args
        if path == ".." do
          {children, tail}
        else
          {:dir, name, sdc} = children[path]
          {sdc, tail} = parse_command(tail, sdc)
          parse_command(tail, %{children | path => {:dir, name, sdc}})
        end
      "ls" ->
        {cwdc, tail} = parse_ls(tail, %{})
        parse_command(tail, cwdc)
    end
  end

  defp parse([line | tail]) do
    if String.starts_with?(line, "$") do
      root_dir = {:dir, "/", %{}}
      {tree, _} = parse_command([line | tail], %{"/" => root_dir})
      tree
    else
      IO.puts "Unexpected line"
      nil
    end
  end

  def size({:file, _name, size}), do: size
  def size({:dir, _name, children}) do
    children
    |> Map.values
    |> Enum.reduce(0, fn c, acc -> size(c) + acc end)
  end

  def find_candidate({:file, _, _}, candidates, _target_size) do
    candidates
  end

  def find_candidate({:dir, name, children} = entry, candidates, target_size) do
    total_size = size(entry)

    if total_size >= target_size do
      find_candidates(children, [{name, total_size} | candidates], target_size)
    else
      find_candidates(children, candidates, target_size)
    end
  end

  def find_candidates(tree, candidates, target_size) do
    tree
    |> Map.values
    |> Enum.reduce(candidates, &find_candidate(&1, &2, target_size))
  end

  def pretty_print({:file, name, size}, indent_size) do
    String.duplicate("\t", indent_size) <> "#{size}\t#{name}"
  end

  def pretty_print({:dir, name, children}, indent_size) do
    # calc total size for fun
    total_size = size({:dir, name, children})
    indent = String.duplicate("\t", indent_size)

    "#{indent}dir\t#{name}\tTotal size: #{total_size}\n" <> (children
    |> Map.values
    |> Enum.map(&pretty_print(&1, indent_size + 1))
    |> Enum.join("\n"))
  end

  def pretty_print(tree) do
    pretty_print(tree["/"], 0)
  end

  def solve(input) do
    fs = input
    |> String.split("\n")
    |> parse

    fs_size = 70000000
    update_size = 30000000
    root_size = size(fs["/"])
    available_space = fs_size - root_size
    target_size = update_size - available_space
    IO.puts "Available space: #{available_space}"
    IO.puts "Target size: #{target_size}"

    find_candidates(fs, [], target_size)
    |> Enum.min_by(fn {_, size} -> size end)
  end
end

AOC.solve 7