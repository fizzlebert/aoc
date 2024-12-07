input = Aoc.input(2024, 5)

[order_str, updates_str] = String.split(input, "\n\n")

order =
  order_str
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split(&1, "|"))
  |> Enum.group_by(fn [_, k] -> k end, fn [v, _] -> v end)

answer =
  updates_str
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split(&1, ","))
  |> Enum.filter(fn updates ->
    0..(length(updates) - 2)
    |> Enum.map(fn length ->
      current = Enum.at(updates, length)
      unprocessed = Enum.take(updates, -length(updates) + length + 1)
      {current, unprocessed}
    end)
    |> Enum.map(fn {update, unprocessed} ->
      invalid_requirements =
        Map.get(order, update, [])
        |> Enum.map(&Enum.member?(unprocessed, &1))
        |> Enum.any?()

      !invalid_requirements
    end)
    |> Enum.all?()
  end)
  |> Enum.map(fn updates ->
    updates
    |> Enum.at(round(length(updates) / 2 - 1))
    |> String.to_integer()
  end)
  |> Enum.sum()

IO.puts(answer)

defmodule Updates do
  def order(order, updates) do
    invalid =
      0..(length(updates) - 2)
      |> Enum.map(fn length ->
        current = Enum.at(updates, length)
        unprocessed = Enum.take(updates, -length(updates) + length + 1)
        {length, current, unprocessed}
      end)
      |> Enum.find_value(fn {length, update, unprocessed} ->
        invalid_value =
          Map.get(order, update, [])
          |> Enum.find(&Enum.member?(unprocessed, &1))

        invalid_index = Enum.find_index(updates, &(&1 == invalid_value))

        case invalid_index do
          nil -> false
          _ -> {length, invalid_index}
        end
      end)

    case invalid do
      nil ->
        updates

      {index_l, index_r} ->
        l = Enum.at(updates, index_l)
        r = Enum.at(updates, index_r)

        swapped =
          updates
          |> List.replace_at(index_l, r)
          |> List.replace_at(index_r, l)

        order(order, swapped)
    end
  end
end

answer2 =
  updates_str
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split(&1, ","))
  |> Enum.filter(fn updates ->
    0..(length(updates) - 2)
    |> Enum.map(fn length ->
      current = Enum.at(updates, length)
      unprocessed = Enum.take(updates, -length(updates) + length + 1)
      {current, unprocessed}
    end)
    |> Enum.map(fn {update, unprocessed} ->
      Map.get(order, update, [])
      |> Enum.map(&Enum.member?(unprocessed, &1))
      |> Enum.any?()
    end)
    |> Enum.any?()
  end)
  |> Enum.map(fn updates ->
    Updates.order(order, updates)
    |> Enum.at(round(length(updates) / 2 - 1))
    |> String.to_integer()
  end)
  |> Enum.sum()

IO.puts(answer2)
