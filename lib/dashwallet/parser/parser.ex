defmodule Dashwallet.Parser do
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
      tags: String.split(","),
      image: image
    }
  end

  def entries_for_trip(data) do
    data
    |> Enum.map(fn %{:trip => trip} -> trip end)
    |> count_occurrences
  end

  defp count_occurrences(list) do
    Enum.reduce(list, %{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
  end
end
