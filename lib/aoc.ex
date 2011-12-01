defmodule Aoc do
  @moduledoc """
  Documentation for `Aoc`.
  """

  @doc """
  Get input for a year and specific day

  ## Examples

      iex> Aoc.input(2024, 1)

  """
  def input(year, day) when is_integer(year) and is_integer(day) do
    folder = "inputs/#{year}"
    file = "#{folder}/#{day}"

    if File.exists?(file) do
      File.read!(file)
      |> process_input()
    else
      session = System.get_env("SESSION") || raise "Environment variable SESSION not set"

      resp =
        Req.get!("https://adventofcode.com/#{year}/day/#{day}/input",
          headers: %{Cookie: "session=#{session}"}
        )

      File.mkdir_p!(folder)
      File.write!(file, resp.body)

      resp.body
      |> process_input()
    end
  end

  defp process_input(input) do
    input
    |> String.split("\n", trim: true)
  end
end
