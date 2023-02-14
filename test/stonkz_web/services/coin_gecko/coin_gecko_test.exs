defmodule StonkzWeb.Services.CoinGeckoTest do
  use ExUnit.Case, async: true
  alias StonkzWeb.Services.CoinGecko

  describe "process_request_url/1" do
    test "returns prepended with base url" do
      CoinGecko.start()
      assert CoinGecko.process_request_url("/coins") == "https://api.coingecko.com/api/v3/coins"
    end
  end

  describe "process_request_headers/1" do
    test "returns new headers with default header" do
      assert CoinGecko.process_request_headers([{"Content-Type", "application/json"}]) ==
               [{"Accept", "application/json"}, {"Content-Type", "application/json"}]
    end
  end

  describe "process_request_body/1" do
    test "returns Jason encoded payload" do
      payload = CoinGecko.process_request_body(%{message: "MESSAGE"})

      assert is_binary(payload)
      assert payload == "{\"message\":\"MESSAGE\"}"
    end
  end

  describe "process_response_body/1" do
    test "returns map response body with atom keys" do
      body = Jason.encode!(%{message: "MESSAGE"})

      payload = CoinGecko.process_response_body(body)

      assert is_map(payload)
      assert payload == %{message: "MESSAGE"}
    end
  end
end
