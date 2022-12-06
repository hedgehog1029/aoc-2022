defmodule AOC.Day do
  def is_signal(window) do
    [{a, _}, {b, _}, {c, _}, {d, _}] = window
    s = MapSet.new([a, b, c, d]) |> MapSet.size
    s == 4
  end

  defp windowed_find([a, b, c, d | tail], cb) do
    if cb.([a, b, c, d]) do
      d
    else
      windowed_find([b, c, d | tail], cb)
    end
  end

  def find_start_signal(data) do
    {_, index} = data
    |> Enum.with_index(1)
    |> windowed_find(&is_signal/1)

    index
  end

  def solve(input) do
    input
    |> String.to_charlist
    |> find_start_signal
  end
end

AOC.solve 6