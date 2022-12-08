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

  def is_visible_dir({x, y} = target, direction, {i, j} = current, {grid, width, height} = gwh) do
    distance = (i + j) - (x + y)
    if grid[current] >= grid[target] do
      # not visible this direction, let's try another
      {false, distance}
    else
      case move(current, {width, height}, direction) do
        {:ok, next} -> is_visible_dir(target, direction, next, gwh)
        {:done} -> {true, distance}  # we've reached an edge, tree is visible!
      end
    end
  end

  def is_visible_dir(entry, direction, {_, width, height} = grid) do
    case move(entry, {width, height}, direction) do
      {:ok, next} -> is_visible_dir(entry, direction, next, grid)
      {:done} -> {true, 0} # already an edge coordinate, short-circuit
    end
  end

  def scenic_score(entry, grid) do
    [:up, :right, :down, :left]
    |> Enum.map(fn dir ->
      {_visible, distance} = is_visible_dir(entry, dir, grid)
      distance
    end)
    |> Enum.product
  end

  def find_highest_scenic(grid, {width, height}) do
    grid
    |> Map.keys
    |> Enum.map(fn coord -> {coord, scenic_score(coord, {grid, width, height})} end)
    |> Enum.max_by(fn {_, score} -> score end)
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
    find_highest_scenic(grid, {w, h})
  end
end

AOC.solve 8