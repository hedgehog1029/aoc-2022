defmodule AOC.Day do
  defp upcase_offset(c) do
    if c < 91 do
      6
    else
      0
    end
  end

  def to_priority(c) do
    Bitwise.bxor(c, 32) - 64 - upcase_offset(c)
  end

  def find_duplicate(line) do
    line = String.to_charlist line
    n = length(line) |> Integer.floor_div(2)
    {a, b} = line |> Enum.split(n)
    first = MapSet.new(a)
    second = MapSet.new(b)

    intersections = MapSet.intersection(first, second)
    |> MapSet.to_list

    if length(intersections) > 0 do
      List.first(intersections) |> to_priority
    else
      0
    end
  end

  def solve(input) do
    lines = input |> String.split("\n")
    lines
    |> Enum.map(&find_duplicate/1)
    |> Enum.sum
  end
end

AOC.solve 3