input = Aoc.input(2024, 3)

parse_mul = fn l ->
  Regex.scan(~r/mul\((?<l>\d+),(?<r>\d+)\)/, l)
  |> Enum.map(&Enum.take(&1, -2))
  |> Enum.reduce(0, fn [l, r], acc ->
    String.to_integer(l) * String.to_integer(r) + acc
  end)
end

answer =
  input
  |> Enum.map(&parse_mul.(&1))
  |> Enum.sum()

IO.puts(answer)

answer2 =
  Regex.split(~r/do\(\)/, Enum.join(input, ""))
  |> Enum.map(fn d ->
    Regex.split(~r/don't\(\)/, d, parts: 2)
    |> List.first()
    |> parse_mul.()
  end)
  |> Enum.sum()

IO.inspect(answer2, charlists: :as_lists)
