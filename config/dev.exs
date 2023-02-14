import Config

config :stonkz, :fb,
  verify_token: System.get_env("VERIFY_TOKEN") || "INSERT_YOUR_TOKEN",
  access_token: System.get_env("FB_ACCESS_TOKEN") || "INSERT_YOUR_TOKEN"

config :stonkz, :services,
  coin_gecko: StonkzWeb.Services.CoinGecko,
  facebook: StonkzWeb.Services.Facebook
