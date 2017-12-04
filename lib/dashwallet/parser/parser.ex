defmodule Dashwallet.Parser do
  require Logger

  @doc """
  Maps a trailwallet data row into a `Map`.

  Returns a parsed `Map`.
  """
  def map_csv([
    trip, date, local_currency, local_amount, home_currency,
    home_amount, category, notes, tags, image
  ]) do
    %{
      trip: trip,
      date: date,
      local_currency: local_currency,
      local_amount: convert_amount_to_float(local_amount),
      home_currency: home_currency,
      home_amount: convert_amount_to_float(home_amount),
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

  @doc """
  Calculates expenses for tags and groups them by tag.

  Returns a `Map` in the following format:
    `%{"Restaurant" => 130.23}`
  """
  def expenses_by_tag(data) do
    data
    |> normalize
    |> Enum.group_by(fn %{tags: [head]} -> head end, fn x -> x.home_amount end)
    |> Enum.reduce(%{}, fn {k, v}, acc -> Map.put(acc, k, Float.round(Enum.sum(v), 2)) end)
  end

  # private

  # selectors

  defp tags(normalized_data) do
    normalized_data
    |> Stream.map(fn %{tags: [tag]} -> tag end)
    |> Stream.uniq
    |> Enum.to_list
  end

  # helper

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

  defp convert_amount_to_float(str) do
    str
    |> String.replace(",", ".")
    |> fix_leading_zeros
    |> Float.parse
    |> case do
      {float, _} -> float
      :error -> raise ArgumentError, message: "Unable to convert given string to float."
    end
  end

  # Adds a leading zero if the trailwallet data has an amount lower than 1.
  # This is a hotfix for a bug in the csv export of trailwallet.
  # Amounts < 1 get exported without a zero, like this: ",43"
  defp fix_leading_zeros(amount) when is_binary(amount), do: String.replace(amount, ~r/^\./, "0.")
end
