defmodule Stonkz.Mocks.CoinGeckoMock do
  def get("/search?query=Dogecoin") do
    {
      :ok,
      %{
        body: %{
          coins: [
            %{
              id: "dogecoin",
              name: "Dogecoin",
              symbol: "DOGE",
              thumb: "https://assets.coingecko.com/coins/images/5/thumb/dogecoin.png"
            },
            %{
              id: "dogecoin-2",
              name: "Dogecoin 2.0",
              symbol: "DOGE2",
              thumb: "https://assets.coingecko.com/coins/images/17539/thumb/k4NUHHaO_400x400.jpg"
            },
            %{
              id: "nano-dogecoin",
              name: "Nano Dogecoin",
              symbol: "INDC",
              thumb: "https://assets.coingecko.com/coins/images/17477/thumb/Untitled-design-6.png"
            },
            %{
              id: "pulsedogecoin",
              name: "PulseDogecoin",
              symbol: "PLSD",
              thumb: "https://assets.coingecko.com/coins/images/25327/thumb/Final_Doge.png"
            },
            %{
              id: "buff-doge-coin",
              name: "Buff Doge Coin",
              symbol: "DOGECOIN",
              thumb: "https://assets.coingecko.com/coins/images/18516/thumb/BUFF_KOIN.png"
            },
            %{
              id: "safedogecoin-v2",
              name: "SafeDogeCoin V2",
              symbol: "SAFEDOGE",
              thumb:
                "https://assets.coingecko.com/coins/images/25259/thumb/My_Post__57_-removebg-preview.png"
            },
            %{
              id: "binance-peg-dogecoin",
              name: "Binance-Peg Dogecoin",
              symbol: "DOGE",
              thumb: "https://assets.coingecko.com/coins/images/15768/thumb/dogecoin.png"
            }
          ]
        },
        status_code: 200
      }
    }
  end

  def get("/search?query=Dyeycoin") do
    {
      :ok,
      %{
        body: %{
          coins: []
        },
        status_code: 200
      }
    }
  end

  def get("/search?query=Errorcoin") do
    {
      :ok,
      %{
        body: %{
          error: "Internal Server Error",
          status: 500
        },
        status_code: 500
      }
    }
  end

  def get("/coins/dogecoin/market_chart" <> _params) do
    {
      :ok,
      %{
        body: %{
          market_caps: [],
          prices: [
            [1_675_209_600_000, 1586.5395765836909],
            [1_675_296_000_000, 1642.857168158598],
            [1_675_382_400_000, 1648.6796840768716],
            [1_675_468_800_000, 1665.4278712238624],
            [1_675_555_200_000, 1667.2716925637008],
            [1_675_641_600_000, 1631.3725233636533],
            [1_675_728_000_000, 1617.144163289206],
            [1_675_814_400_000, 1672.8226777758136],
            [1_675_900_800_000, 1651.4083786023796],
            [1_675_987_200_000, 1546.383768658398],
            [1_676_073_600_000, 1515.5340268615535],
            [1_676_160_000_000, 1541.9688769412712],
            [1_676_246_400_000, 1515.3346311806397],
            [1_676_332_800_000, 1506.9162010135053],
            [1_676_380_279_000, 1514.1455922637706]
          ],
          total_volumes: []
        },
        status_code: 200
      }
    }
  end

  def get("/coins/dyeycoin/market_chart" <> _params) do
    {
      :ok,
      %{
        body: %{
          error: "coin not found"
        },
        status_code: 404
      }
    }
  end

  def get("/coins/errorcoin/market_chart" <> _params) do
    {
      :ok,
      %{
        body: %{
          error: "Internal Server Error",
          status: 500
        },
        status_code: 500
      }
    }
  end

  def get("/coins/dogecoin" <> _params) do
    {
      :ok,
      %{
        body: %{
          categories: ["Cryptocurrency", "BNB Chain Ecosystem", "Meme"],
          coingecko_rank: 6,
          description: %{
            en: "Dogecoin is a cryptocurrency based on the popular \"Doge\" Internet meme..."
          },
          id: "dogecoin",
          image: %{
            large: "https://assets.coingecko.com/coins/images/5/large/dogecoin.png?1547792256",
            small: "https://assets.coingecko.com/coins/images/5/small/dogecoin.png?1547792256",
            thumb: "https://assets.coingecko.com/coins/images/5/thumb/dogecoin.png?1547792256"
          },
          last_updated: "2023-02-14T13:08:51.739Z",
          liquidity_score: 66.788,
          market_cap_rank: 9,
          name: "Dogecoin",
          symbol: "doge"
        },
        status_code: 200
      }
    }
  end

  def get("/coins/dyeycoin" <> _params) do
    {
      :ok,
      %{
        body: %{
          error: "coin not found"
        },
        status_code: 404
      }
    }
  end

  def get("/coins/errorcoin" <> _params) do
    {
      :ok,
      %{
        body: %{
          error: "Internal Server Error",
          status: 500
        },
        status_code: 500
      }
    }
  end

  def get(_) do
    {:error, %HTTPoison.Error{}}
  end
end
