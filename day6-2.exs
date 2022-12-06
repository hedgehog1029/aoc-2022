defmodule AOC.Day do
  def is_signal(window, n) do
    s = MapSet.new(window) |> MapSet.size
    s == n
  end

  defp windowed_find(list, n, i \\ 0) do
    {window, tail} = Enum.split(list, n)
    if is_signal(window, n) do
      i + n
    else
      [_ | tt] = window
      windowed_find(tt ++ tail, n, i + 1)
    end
  end

  def find_start_signal(data) do
    windowed_find(data, 14)
  end

  def solve(input) do
    input
    |> String.to_charlist
    |> find_start_signal
  end
end

AOC.solve 6