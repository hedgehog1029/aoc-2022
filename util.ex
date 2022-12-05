defmodule AOC do
  def input(n) do
    File.read!("inputs/day#{n}.txt")
  end

  def solve(n) do
    input(n) |> AOC.Day.solve |> IO.inspect
  end
end