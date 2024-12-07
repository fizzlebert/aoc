input =
  Aoc.input(2024, 2)
  |> String.split("\n", trim: true)

answer =
  input
  |> Enum.filter(fn l ->
    deltas =
      l
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [l, r] -> l - r end)

    !(Enum.any?(deltas, &(&1 < 0)) and
        Enum.any?(deltas, &(&1 > 0))) and
      !Enum.any?(deltas, fn delta ->
        abs(delta) > 3 or delta == 0
      end)
  end)
  |> then(&length/1)

IO.puts(answer)

defmodule Report do
  def safe_report(report) do
    deltas =
      report
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [l, r] -> l - r end)

    !(Enum.any?(deltas, &(&1 < 0)) and
        Enum.any?(deltas, &(&1 > 0))) and
      !Enum.any?(deltas, fn delta ->
        abs(delta) > 3 or delta == 0
      end)
  end

  def safe_danger_report(report, i) when i + 1 > length(report) do
    false
  end

  def safe_danger_report(report, i) do
    safe =
      report
      |> List.delete_at(i)
      |> Report.safe_report()

    safe or Report.safe_danger_report(report, i + 1)
  end
end

answer2 =
  input
  |> Enum.filter(fn l ->
    report =
      l
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)

    if Report.safe_report(report) do
      true
    else
      Report.safe_danger_report(report, 0)
    end
  end)
  |> then(&length/1)

IO.puts(answer2)
