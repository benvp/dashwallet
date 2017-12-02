defmodule Dashwallet.Cache do
  @cache :dashwallet

  def id, do: UUID.uuid4()

  def get(key), do: Cachex.get(@cache, key)
  def get!(key), do: Cachex.get!(@cache, key)
  def set(key, value, ttl \\ :timer.hours(1)), do: Cachex.set(@cache, key, value, ttl: ttl)
end
