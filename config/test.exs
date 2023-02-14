import Config

config :stonkz, :fb,
  verify_token: "VERIFY_TOKEN_12345",
  access_token: "FB_ACCESS_TOKEN_12345"

config :stonkz, :services,
  coin_gecko: Stonkz.Mocks.CoinGeckoMock,
  facebook: Stonkz.Mocks.FacebookMock

config :plug, :validate_header_keys_during_test, false
