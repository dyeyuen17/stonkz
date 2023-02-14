# Stonkz
Stonkz! The most exciting way to get crypto updates for free!

## Description
Stonkz is a Messenger chatbot back-end made with Elixir, used for inquiring cryptocurrency updates from CoinGecko.

deployed at Gigalixir: https://stonkz.gigalixirapp.com/helth_check

## How it works?
  ![replay](/demo.gif)

## Making it work
- First, you must have the ff:
	- Facebook Page, 
	- Facebook developer app with messenger and webhooks product. 
	- Acquire Facebook `ACCESS_TOKEN`.
	- Generate `VERIFY_TOKEN`
	see https://developers.facebook.com/docs/messenger-platform/overview for more details.

- To run locally,
	1. Put your `VERIFY_TOKEN` and `ACCESS_TOKEN` in docker-compose.yml file
	2. Run `docker compose up`.
	3. To expose your local server to the internet, you can use services like ngrok.io

## File Structure
```
  lib
  |
  +-stonkz
  | +-utils
  | | +--date.ex
  | |
  | +--application.ex
  | +--user_cache.ex
  |
  +-stonkz_web
    +-handlers
    | +--events.ex
    | +--payloads.ex
    | +--templates.ex
    |
    +-plugs
    | +--webhooks.ex
    |
    +-services
    | +-coin_gecko
    | | +--coin_gecko_api.ex
    | | +--coin_gecko.ex
    | |
    | +-facebook
    |   +-facebook_api.ex
    |   +-facebook.ex
    |
    +-router.ex
```

## Test Coverage
  ![Screenshot](/test.png)
  


