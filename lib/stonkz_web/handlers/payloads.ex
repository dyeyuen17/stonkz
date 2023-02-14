defmodule StonkzWeb.Handlers.Payloads do
  import StonkzWeb.Handlers.Templates
  alias Stonkz.Utils.Date

  @spec get_started_payload(String.t(), map()) :: list(map())
  def get_started_payload(sender_psid, user_data) do
    name = user_data[:first_name] || "User"

    [
      text_template(
        sender_psid,
        "Get Stonked #{name}! Unleash exciting crypto updates with Stonkz!"
      ),
      sender_action_template(sender_psid, "typing_on"),
      buttons_template(
        sender_psid,
        "See the latest crypto prices!",
        [
          button_template("NAME_SEARCH", "Search by name"),
          button_template("ID_SEARCH", "Search by ID")
        ]
      )
    ]
  end

  @spec enter_crypto_payload(String.t(), String.t()) :: list(map())
  def enter_crypto_payload(sender_psid, search_type) do
    text_template(
      sender_psid,
      "Please enter crypto #{search_type}"
    )
  end

  @spec crypto_list_payload(String.t(), list(map())) :: map()
  def crypto_list_payload(sender_psid, coins) do
    elements = Enum.map(coins, &generic_elements_payload/1)
    generic_template(sender_psid, elements)
  end

  @spec crypto_payload(String.t(), map()) :: map()
  def crypto_payload(sender_psid, coin) do
    element =
      generic_elements_payload(%{
        id: coin.id,
        name: coin.name,
        symbol: String.upcase(coin.symbol),
        thumb: coin.image.small
      })

    generic_template(sender_psid, [element])
  end

  @doc """
    This function builds message payload for coin history result, and attribution to CoinGecko
  """
  @spec price_history_payload(String.t(), list()) :: map()
  def price_history_payload(sender_psid, prices) do
    title = "Here is the price history in the last 14 days\n"

    price_history =
      prices
      |> Enum.take(14)
      |> Enum.reduce(title, fn [timestamp, price], acc ->
        acc <> "\n #{Date.parse(timestamp)}: $#{price}"
      end)

    [
      text_template(sender_psid, price_history),
      buttons_template(
        sender_psid,
        "Powered by CoinGecko",
        [
          url_button_template("https://www.coingecko.com/", "Visit Website"),
          button_template("START_OVER", "Start Over")
        ]
      )
    ]
  end

  @spec crypto_not_found_payload(String.t(), String.t()) :: map()
  def crypto_not_found_payload(sender_psid, coin_name) do
    buttons_template(
      sender_psid,
      "We couln't find #{coin_name} in the list. Try again!",
      [
        button_template("NAME_SEARCH", "Search by name"),
        button_template("ID_SEARCH", "Search by ID")
      ]
    )
  end

  @spec retry_payload(String.t()) :: map()
  def retry_payload(sender_psid) do
    buttons_template(
      sender_psid,
      "We couln't process your request. Please try again.",
      [button_template("START_OVER", "Start Over")]
    )
  end

  @spec sender_action_payload(String.t(), String.t()) :: map()
  def sender_action_payload(sender_psid, sender_action) do
    sender_action_template(sender_psid, sender_action)
  end

  @spec generic_elements_payload(map()) :: map
  def generic_elements_payload(coin) do
    default_action =
      generic_default_action_template("https://www.coingecko.com/en/coins/#{coin[:id]}")

    button = button_template("COIN_HISTORY:#{coin[:id]}", "Show History")

    generic_element_template(
      %{
        title: coin[:name],
        image_url: String.replace(coin[:thumb], "/thumb/", "/large/"),
        subtitle: coin[:symbol]
      },
      default_action,
      [button]
    )
  end
end
