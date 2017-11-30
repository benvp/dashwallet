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
      tags: tags,
      image: image
    }
  end
end
