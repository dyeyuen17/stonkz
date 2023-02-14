defmodule Stonkz.UserCache do
  use GenServer

  @moduledoc """
    This module starts when the application starts.
    Creates new ets table for storing and managing user states
  """

  def start_link(_state) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    :ets.new(:user_cache, [
      :set,
      :public,
      :named_table
    ])

    {:ok, state}
  end

  # Stores new record to table
  def store(sender_psid, data) do
    :ets.insert(:user_cache, {sender_psid, data})
  end

  # Gets and store new set of data replacing the old.
  def update(sender_psid, new_data) do
    data = get(sender_psid)

    :ets.insert(:user_cache, {sender_psid, Map.merge(data, new_data)})
  end

  # Gets data from the cache table.
  def get(sender_psid) do
    case :ets.lookup(:user_cache, sender_psid) do
      [] ->
        %{}

      [{_key, data}] ->
        data
    end
  end

  # Removes record from the cache table.
  def delete(sender_psid) do
    :ets.delete(:user_cache, sender_psid)
  end
end
