defmodule StonkzWeb.Services.CoinGeckoAPITest do
  use ExUnit.Case, async: true
  alias StonkzWeb.Services.CoinGeckoAPI

  describe "search_crypto_by_name/1 tests" do
    test "returns coins data" do
      assert {:ok, coins} = CoinGeckoAPI.search_crypto_by_name("Dogecoin")
      assert [%{id: "dogecoin"} | _] = coins
      assert length(coins) == 7
    end

    test "returns empty coin list if there is no result" do
      assert {:ok, coins} = CoinGeckoAPI.search_crypto_by_name("Dyeycoin")
      assert Enum.empty?(coins)
    end

    test "returns error if request failed" do
      assert {:error, error} = CoinGeckoAPI.search_crypto_by_name("Errorcoin")
      assert error == %{error: "Internal Server Error", status: 500}
    end

    test "returns error if something went wrong" do
      assert {:error, error} = CoinGeckoAPI.search_crypto_by_name("invalid")
      assert error == %HTTPoison.Error{}
    end
  end

  describe "search_crypto_by_id/1 tests" do
    test "returns coin data" do
      assert {:ok, coin} = CoinGeckoAPI.search_crypto_by_id("dogecoin")
      assert %{id: "dogecoin", name: "Dogecoin"} = coin
    end

    test "returns error if coin not found" do
      assert {:error, error} = CoinGeckoAPI.search_crypto_by_id("dyeycoin")
      assert error == %{error: "coin not found"}
    end

    test "returns error if request failed" do
      assert {:error, error} = CoinGeckoAPI.search_crypto_by_id("errorcoin")
      assert error == %{error: "Internal Server Error", status: 500}
    end

    test "returns error if something went wrong" do
      assert {:error, error} = CoinGeckoAPI.search_crypto_by_id("invalid")
      assert error == %HTTPoison.Error{}
    end
  end

  describe "get_crypto_history/1 tests" do
    test "returns coin market history data" do
      assert {:ok, prices} = CoinGeckoAPI.get_crypto_history("dogecoin")
      assert [[1_675_209_600_000, 1586.5395765836909] | _] = prices
      assert length(prices) == 15
    end

    test "returns error if coin not found" do
      assert {:error, error} = CoinGeckoAPI.get_crypto_history("dyeycoin")
      assert error == %{error: "coin not found"}
    end

    test "returns error if request failed" do
      assert {:error, error} = CoinGeckoAPI.get_crypto_history("errorcoin")
      assert error == %{error: "Internal Server Error", status: 500}
    end

    test "returns error if something went wrong" do
      assert {:error, error} = CoinGeckoAPI.get_crypto_history("invalid")
      assert error == %HTTPoison.Error{}
    end
  end
end
