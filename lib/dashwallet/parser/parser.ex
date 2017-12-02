defmodule Dashwallet.Parser do
  require Logger

  def map_csv([
    trip, date, local_currency, local_amount, home_currency,
    home_amount, category, notes, tags, image
  ]) do
    %{
      trip: trip,
      date: date,
      local_currency: local_currency,
      local_amount: local_amount,
      home_currency: home_currency,
      home_amount: home_amount,
      category: category,
      notes: notes,
      tags: split_and_trim(tags),
      image: image
    }
  end

  def entries_for_trip(data) do
    data
    |> Enum.map(fn %{:trip => trip} -> trip end)
    |> count_occurrences
  end

  def has_multiple_tags(row) do
    Enum.count(row.tags) > 1
  end

  def group_by_tags(data) do
    data
    |> normalize
    |> Enum.group_by(fn %{tags: [head]} -> head end)
  end

  # private

  defp normalize(data) do
    single_tags = Stream.filter(data, &(!has_multiple_tags(&1)))

    data
    |> Stream.filter(&(has_multiple_tags(&1)))
    |> Stream.map(fn x -> Enum.map(x.tags, &Map.merge(x, %{tags: [&1]})) end)
    |> Stream.flat_map(fn x -> x end)
    |> Stream.concat(single_tags)
    |> Enum.to_list
  end

  defp split_and_trim(str) when is_binary(str) do
    str
    |> String.split(",")
    |> Enum.map(&(String.trim(&1)))
  end

  defp count_occurrences(list) do
    Enum.reduce(list, %{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
  end
end
