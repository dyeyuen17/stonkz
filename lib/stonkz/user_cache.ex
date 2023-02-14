defmodule Stonkz.UserCache do
  use GenServer

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

  def store(sender_psid, data) do
    :ets.insert(:user_cache, {sender_psid, data})
  end

  def update(sender_psid, new_data) do
    data = get(sender_psid)

    :ets.insert(:user_cache, {sender_psid, Map.merge(data, new_data)})
  end

  def get(sender_psid) do
    case :ets.lookup(:user_cache, sender_psid) do
      [] ->
        %{}

      [{_key, data}] ->
        data
    end
  end

  def delete(sender_psid) do
    :ets.delete(:user_cache, sender_psid)
  end
end
