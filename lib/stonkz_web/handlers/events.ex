defmodule StonkzWeb.Handlers.Events do
  alias Stonkz.UserCache
  alias StonkzWeb.Handlers.Payloads

  alias StonkzWeb.Services.{
    CoinGeckoAPI,
    FacebookAPI
  }

  @moduledoc """
    This module handles incoming webhooks and sends the appropriate response to Meta Graph API.
  """

  @doc """
    Handles initial user interaction with both with Get Started button and Start Over
    Sends greeting and prompts Search options to user.
  """
  @spec handle_entry(map()) :: {:ok, map()} | {:error, map()} | list(map())
  def handle_entry([
        %{
          "messaging" => [
            %{
              "postback" => %{
                "payload" => payload
              },
              "sender" => %{"id" => sender_psid}
            }
          ]
        }
      ])
      when payload in ["GET_STARTED", "START_OVER"] do
    send_actions(sender_psid)

    user_data = create_user_data(sender_psid)

    sender_psid
    |> Payloads.get_started_payload(user_data)
    |> send_reply()
  end

  # Handles user button interaction from Search options
  # Sends prompt asking user to enter the coin id or name.
  def handle_entry([
        %{
          "messaging" => [
            %{
              "postback" => %{
                "payload" => payload_type,
                "title" => "Search by " <> search_type
              },
              "sender" => %{"id" => sender_psid}
            }
          ]
        }
      ])
      when payload_type in ["NAME_SEARCH", "ID_SEARCH"] do
    send_actions(sender_psid)

    UserCache.update(sender_psid, %{search_type: search_type})

    sender_psid
    |> Payloads.enter_crypto_payload(search_type)
    |> send_reply()
  end

  # Handles user action for the Show History button.
  # Sends a text message showing the last 14 days market price.

  def handle_entry([
        %{
          "messaging" => [
            %{
              "postback" => %{
                "payload" => "COIN_HISTORY:" <> coin_id,
                "title" => "Show History"
              },
              "sender" => %{"id" => sender_psid}
            }
          ]
        }
      ]) do
    send_actions(sender_psid)

    handle_history_response(sender_psid, coin_id)
  end

  # Handles user reply for the coin name or id prompt.
  # Sends a generic template or a carousel top crypto options with Show History button.

  def handle_entry([
        %{
          "messaging" => [
            %{
              "message" => %{
                "text" => coin_name_or_id
              },
              "sender" => %{"id" => sender_psid}
            }
          ]
        }
      ]) do
    send_actions(sender_psid)

    user_data = UserCache.get(sender_psid)
    UserCache.update(sender_psid, %{coin: coin_name_or_id})

    handle_search_response(sender_psid, coin_name_or_id, user_data[:search_type])
  end

  # Handles user's random messages.
  # Sends sender action mark as seen.

  def handle_entry([
        %{
          "messaging" => [
            %{
              "sender" => %{"id" => sender_psid}
            }
          ]
        }
      ]) do
    send_action(sender_psid, "mark_seen")
  end

  def handle_entry(_entries), do: :ok

  @spec handle_search_response(String.t(), String.t(), String.t()) ::
          {:ok, map()} | {:error, map()}
  defp handle_search_response(sender_psid, crypto_id, "ID") do
    case CoinGeckoAPI.search_crypto_by_id(crypto_id) do
      {:ok, coin} ->
        sender_psid
        |> Payloads.crypto_payload(coin)
        |> send_reply()

      _error ->
        sender_psid
        |> Payloads.retry_payload()
        |> send_reply()
    end
  end

  defp handle_search_response(sender_psid, coin_name, _) do
    case CoinGeckoAPI.search_crypto_by_name(coin_name) do
      {:ok, []} ->
        sender_psid
        |> Payloads.crypto_not_found_payload(coin_name)
        |> send_reply()

      {:ok, coins} ->
        top_results = Enum.take(coins, 5)

        sender_psid
        |> Payloads.crypto_list_payload(top_results)
        |> send_reply()

      _error ->
        sender_psid
        |> Payloads.retry_payload()
        |> send_reply()
    end
  end

  @spec handle_history_response(String.t(), String.t()) :: {:ok, map()} | {:error, map()}
  defp handle_history_response(sender_psid, coin_id) do
    case CoinGeckoAPI.get_crypto_history(coin_id) do
      {:ok, prices} ->
        UserCache.delete(sender_psid)

        sender_psid
        |> Payloads.price_history_payload(prices)
        |> send_reply()

      _error ->
        sender_psid
        |> Payloads.retry_payload()
        |> send_reply()
    end
  end

  @spec create_user_data(String.t()) :: map()
  defp create_user_data(sender_psid) do
    case UserCache.get(sender_psid) do
      %{name: _name} = data ->
        data

      _ ->
        data = get_user_fb_data(sender_psid)
        UserCache.store(sender_psid, data)

        data
    end
  end

  @spec get_user_fb_data(String.t()) :: map()
  defp get_user_fb_data(sender_psid) do
    case FacebookAPI.get_user_data(sender_psid) do
      {:ok, %{id: _} = data} ->
        data

      _ ->
        %{}
    end
  end

  defp send_actions(sender_psid) do
    send_action(sender_psid, "mark_seen")
    send_action(sender_psid, "typing_on")
  end

  defp send_action(sender_psid, sender_action) do
    sender_psid
    |> Payloads.sender_action_payload(sender_action)
    |> FacebookAPI.send_response()
  end

  defp send_reply([body | _] = payload) when is_list(payload) do
    send_action(body.recipient.id, "typing_off")

    FacebookAPI.send_response(payload)
  end

  defp send_reply(payload) do
    send_action(payload.recipient.id, "typing_off")

    FacebookAPI.send_response(payload)
  end
end
