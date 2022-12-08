defmodule AOC.Day do
  defp move({i, j}, {width, height}, direction) do
    {x, y} = case direction do
      :up -> {i, j - 1}
      :down -> {i, j + 1}
      :left -> {i - 1, j}
      :right -> {i + 1, j}
    end

    if Enum.any?([x < 0, x >= width, y < 0, y >= height]) do
      {:done}
    else
      {:ok, {x, y}}
    end
  end

  def is_visible_dir(target, direction, current, {grid, width, height} = gwh) do
    if grid[current] == nil or grid[target] == nil do
      IO.puts "nil grid value"
    end
    if grid[current] >= grid[target] do
      # not visible this direction, let's try another
      false
    else
      case move(current, {width, height}, direction) do
        {:ok, next} -> is_visible_dir(target, direction, next, gwh)
        {:done} -> true  # we've reached an edge, tree is visible!
      end
    end
  end

  def is_visible_dir(entry, direction, {_, width, height} = grid) do
    case move(entry, {width, height}, direction) do
      {:ok, next} -> is_visible_dir(entry, direction, next, grid)
      {:done} -> true # already an edge coordinate, short-circuit
    end
  end

  def is_visible(entry, grid) do
    [:up, :right, :down, :left]
    |> Enum.any?(&is_visible_dir(entry, &1, grid))
  end

  def find_visible(grid, {width, height}) do
    grid
    |> Map.keys
    |> Enum.filter(&is_visible(&1, {grid, width, height}))
  end

  def parse({line, y}) do
    line
    |> String.to_charlist
    |> Enum.map(fn c -> c - 48 end)
    |> Enum.with_index(fn c, x -> {x, y, c} end)
  end

  defp lengths(input) do
    lines = String.split(input, "\n")
    width = lines |> hd |> String.length
    height = lines |> length
    {width, height}
  end

  def solve(input) do
    grid = input
    |> String.split("\n")
    |> Enum.with_index
    |> Enum.flat_map(&parse/1)
    |> Map.new(fn {x, y, c} -> {{x, y}, c} end)

    {w, h} = lengths(input)
    find_visible(grid, {w, h})
    |> length
  end
end

AOC.solve 8