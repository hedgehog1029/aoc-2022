defmodule AOC.Day do
  def score_of(x) do
    case x do
      :rock -> 1
      :paper -> 2
      :scissors -> 3
      :loss -> 0
      :draw -> 3
      :win -> 6
    end
  end

  def compare(a, b) do
    result = case {a, b} do
      {x, :draw} -> x
      {:rock, :loss} -> :scissors
      {:rock, :win} -> :paper
      {:paper, :loss} -> :rock
      {:paper, :win} -> :scissors
      {:scissors, :loss} -> :paper
      {:scissors, :win} -> :rock
    end

    score_of(result) + score_of(b)
  end

  def parse(x) do
    case x do
      "A" -> :rock
      "B" -> :paper
      "C" -> :scissors
      "X" -> :loss
      "Y" -> :draw
      "Z" -> :win
    end
  end

  def play(strategy) do
    [theirs, yours] = strategy |> String.split(" ") |> Enum.map(&parse/1)
    compare(theirs, yours)
  end

  def solve(input) do
    rounds = input |> String.split("\n")
    rounds |> Enum.map(&play/1) |> Enum.sum
  end
end

AOC.solve 2
