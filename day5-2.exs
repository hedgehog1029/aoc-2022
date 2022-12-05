defmodule AOC.Day do
  defp read_stack(line) do
    line
    |> String.split(",")
    |> Enum.reverse
  end

  def read_stacks do
    File.read!("inputs/day5-stacks.txt")
    |> String.split("\n")
    |> Enum.map(&read_stack/1)
    |> Enum.with_index(fn e, i -> {i + 1, e} end)
    |> Map.new
  end

  def run({:move, count, src, dst}, stacks) do
    ssrc = Map.get(stacks, src)
    sdst = Map.get(stacks, dst)
    {taken, rest} = ssrc |> Enum.split(count)

    stacks
    |> Map.put(src, rest)
    |> Map.put(dst, taken ++ sdst)
  end

  def parse_instruction(ins) do
    [_h | tail] = Regex.run(~r/move (\d+) from (\d+) to (\d+)/, ins)
    [count, src, dst] = tail |> Enum.map(&String.to_integer/1)
    {:move, count, src, dst}
  end

  def solve(input) do
    stacks = read_stacks()
    input
    |> String.split("\n")
    |> Enum.map(&parse_instruction/1)
    |> Enum.reduce(stacks, &run/2)
    |> Map.values
    |> Enum.map_join(&List.first/1)
  end
end

AOC.solve 5