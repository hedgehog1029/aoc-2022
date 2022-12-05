defmodule AOC.Day do
  defp to_ranges(line) do
    to_range = fn x ->
      [a, b] = x
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)
      Range.new(a, b)
    end

    line |> String.split(",") |> Enum.map(to_range)
  end

  def find_full_overlaps([a, b]) do
    not Range.disjoint?(a, b)
  end

  def solve(input) do
    input
    |> String.split("\n")
    |> Enum.map(&to_ranges/1)
    |> Enum.filter(&find_full_overlaps/1)
    |> length
  end
end

AOC.solve 4