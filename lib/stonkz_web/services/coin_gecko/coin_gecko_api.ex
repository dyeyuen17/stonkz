defmodule StonkzWeb.Services.CoinGeckoAPI do
  @coin_gecko Application.compile_env(:stonkz, [:services, :coin_gecko])

  @doc """
    Search for coins, categories and markets listed on CoinGecko ordered by largest Market Cap first.
  """
  def search_crypto_by_name(crypto_name) do
    case @coin_gecko.get("/search?query=#{crypto_name}") do
      {:ok, %{body: %{coins: coins}, status_code: 200}} ->
        {:ok, coins}

      {:ok, %{body: body}} ->
        {:error, body}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
    Get current data (name, price, market, ...etc) for a crypto.
  """
  def search_crypto_by_id(crypto_id) do
    case @coin_gecko.get(
           "/coins/#{crypto_id}?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
         ) do
      {:ok, %{body: body, status_code: 200}} ->
        {:ok, body}

      {:ok, %{body: body}} ->
        {:error, body}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
    Get crypto historical market data include price, market cap, and 24h volume
  """
  def get_crypto_history(crypto_id) do
    case @coin_gecko.get(
           "/coins/#{crypto_id}/market_chart?vs_currency=usd&days=14&interval=daily"
         ) do
      {:ok, %{body: %{prices: prices}, status_code: 200}} ->
        {:ok, prices}

      {:ok, %{body: body}} ->
        {:error, body}

      {:error, error} ->
        {:error, error}
    end
  end
end
