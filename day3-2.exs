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

  defp to_set(line) do
    line
    |> String.to_charlist
    |> MapSet.new
  end

  def find_duplicates(group) do
    [a, b, c] = group |> Enum.map(&to_set/1)
    MapSet.intersection(a, b)
    |> MapSet.intersection(c)
    |> MapSet.to_list
    |> List.first
    |> to_priority
  end

  def solve(input) do
    lines = input |> String.split("\n")
    lines
    |> Enum.chunk_every(3)
    |> Enum.map(&find_duplicates/1)
    |> Enum.sum
  end
end

AOC.solve 3