defmodule AOC.Day do
  defp map_entry(entry) do
    entry
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum
  end

  def solve(input) do
    elves = input |> String.split("\n\n") |> Enum.map(&map_entry/1)
    Enum.max(elves)
  end
end

AOC.solve 1