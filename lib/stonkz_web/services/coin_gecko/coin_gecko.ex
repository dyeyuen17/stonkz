defmodule StonkzWeb.Services.CoinGecko do
  @moduledoc """
    this custom module wraps the functionalities and callbacks provided by HTTPoison end used by CoinGeckoAPI.
  """

  use HTTPoison.Base

  @url "https://api.coingecko.com/api/v3"

  def process_request_url(url), do: @url <> url

  def process_request_headers(headers) do
    [{"Accept", "application/json"}] ++ headers
  end

  def process_request_body(body) do
    Jason.encode!(body)
  end

  def process_response_body(body) do
    Jason.decode!(body, keys: :atoms)
  end
end
