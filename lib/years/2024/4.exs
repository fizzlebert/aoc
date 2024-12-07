input =
  Aoc.input(2024, 4)
  |> String.split("\n", trim: true)

# Regex.scan returns non overlapping but since xmas has no repeating
# chars no possible overlaps

xmas = fn l ->
  [l, String.reverse(l)]
  |> Enum.map(fn s ->
    length(Regex.scan(~r/XMAS/, s))
  end)
  |> Enum.sum()
end

horizonal =
  input
  |> Enum.map(&xmas.(&1))
  |> Enum.sum()

lines =
  input
  |> Enum.map(&String.split(&1, "", trim: true))

vertical =
  Enum.zip(lines)
  |> Enum.map(fn l ->
    l
    |> Tuple.to_list()
    |> Enum.reduce(fn c, acc -> acc <> c end)
    |> xmas.()
  end)
  |> Enum.sum()

xmas_diagonal = fn lines_indexes, desired ->
  lines_indexes
  |> Enum.map(fn {l, i} ->
    l
    |> Enum.map(fn {c, j} ->
      case i + j do
        ^desired -> c
        _ -> ""
      end
    end)
    |> Enum.join()
  end)
  |> Enum.join()
  |> xmas.()
end

lines_forward_indexes =
  lines
  |> Enum.map(&Enum.with_index/1)
  |> Enum.with_index()

lines_reverse_indexes =
  lines
  |> Enum.map(&Enum.reverse/1)
  |> Enum.map(&Enum.with_index/1)
  |> Enum.with_index()

diagonal =
  0..(length(lines) + length(List.first(lines)))
  |> Enum.map(fn desired ->
    xmas_diagonal.(lines_forward_indexes, desired) +
      xmas_diagonal.(lines_reverse_indexes, desired)
  end)
  |> Enum.sum()

answer = horizonal + vertical + diagonal
IO.puts(answer)

x_mas = fn
  [["M", _, "M"], [_, "A", _], ["S", _, "S"]] -> true
  [["M", _, "S"], [_, "A", _], ["M", _, "S"]] -> true
  [["S", _, "M"], [_, "A", _], ["S", _, "M"]] -> true
  [["S", _, "S"], [_, "A", _], ["M", _, "M"]] -> true
  _ -> false
end

answer2 =
  lines
  |> Enum.chunk_every(3, 1, :discard)
  |> Enum.map(fn chunk ->
    chunk
    |> Enum.map(&Enum.chunk_every(&1, 3, 1, :discard))
    |> Enum.zip()
    |> Enum.map(fn kernel ->
      case x_mas.(Tuple.to_list(kernel)) do
        true -> 1
        false -> 0
      end
    end)
    |> Enum.sum()
  end)
  |> Enum.sum()

IO.puts(answer2)
