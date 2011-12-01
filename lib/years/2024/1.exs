input = Aoc.input(2024, 1)

# O(n)
{left, right} =
  input
  |> Enum.map(fn l ->
    String.split(l, "   ")
    |> Enum.map(&String.to_integer/1)
  end)
  |> Enum.reduce({[], []}, fn [l, r], {l_list, r_list} -> {[l | l_list], [r | r_list]} end)

# O(n log(n) + n)
# merge sort + calculating difference of each item
answer =
  Enum.zip(Enum.sort(left), Enum.sort(right))
  |> Enum.map(fn {l, r} -> abs(l - r) end)
  |> Enum.sum()

IO.puts(answer)

# O(n^2)
# iterate over list twice to find count?
counts =
  right
  |> Enum.uniq()
  |> Enum.map(fn n -> {n, Enum.count(right, &(&1 == n))} end)
  |> Enum.reduce(%{}, fn {n, count}, acc -> Map.put(acc, n, count) end)

# O(n)
answer2 =
  left
  |> Enum.map(fn n ->
    case Map.get(counts, n) do
      nil -> 0
      count -> n * count
    end
  end)
  |> Enum.sum()

IO.puts(answer2)
