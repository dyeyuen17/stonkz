defmodule StonkzWeb.Services.FacebookAPITest do
  use ExUnit.Case, async: true
  alias StonkzWeb.Services.FacebookAPI

  describe "send_response/1 tests" do
    test "returns back recipient data for sender action template" do
      payload = %{recipient: %{id: "1234567890"}, sender_action: "typing_on"}

      assert {:ok, body} = FacebookAPI.send_response(payload)
      assert %{recipient_id: "1234567890"} = body
    end

    test "returns back recipients data multiple payloads" do
      payload = [
        %{recipient: %{id: "1234567890"}, sender_action: "typing_on"},
        %{recipient: %{id: "1234567890"}, sender_action: "typing_off"}
      ]

      assert [body | _] = FacebookAPI.send_response(payload)
      assert {:ok, %{recipient_id: "1234567890"}} = body
    end

    test "returns success for text template payload" do
      payload = %{
        message: %{
          text: "Get Stonked Dyey!"
        },
        messaging_type: "RESPONSE",
        recipient: %{id: "1234567890"}
      }

      assert {:ok, body} = FacebookAPI.send_response(payload)
      assert %{recipient_id: "1234567890"} = body
    end

    test "returns success for button template payload" do
      payload = %{
        message: %{
          attachment: %{
            payload: %{
              buttons: [
                %{payload: "NAME_SEARCH", title: "Search by name", type: "postback"},
                %{payload: "ID_SEARCH", title: "Search by ID", type: "postback"}
              ],
              template_type: "button",
              text: "See the latest crypto prices!"
            },
            type: "template"
          }
        },
        messaging_type: "RESPONSE",
        recipient: %{id: "1234567890"}
      }

      assert {:ok, body} = FacebookAPI.send_response(payload)
      assert %{recipient_id: "1234567890"} = body
    end

    test "returns success for generic template payload" do
      payload = %{
        message: %{
          attachment: %{
            payload: %{
              elements: [
                %{
                  buttons: [
                    %{
                      payload: "COIN_HISTORY:bitcoin",
                      title: "Show History",
                      type: "postback"
                    }
                  ],
                  default_action: %{
                    type: "web_url",
                    url: "https://www.coingecko.com/en/coins/bitcoin",
                    webview_height_ratio: "full"
                  },
                  image_url: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
                  subtitle: "BTC",
                  title: "Bitcoin"
                }
              ],
              template_type: "generic"
            },
            type: "template"
          }
        },
        recipient: %{id: "1234567890"}
      }

      assert {:ok, body} = FacebookAPI.send_response(payload)
      assert %{recipient_id: "1234567890"} = body
    end

    test "returns error sender_psid is invalid" do
      payload = %{recipient: %{id: "0000000000"}, sender_action: "typing_off"}

      assert {:error, %{error: error}} = FacebookAPI.send_response(payload)
      assert %{code: 100, type: "OAuthException"} = error
    end

    test "returns error if something went wrong" do
      assert {:error, error} = FacebookAPI.send_response(%{error: "invalid_payload"})
      assert error == %HTTPoison.Error{}
    end
  end

  describe "get_user_data/1 tests" do
    test "returns user data" do
      assert {:ok, body} = FacebookAPI.get_user_data("1234567890")

      assert %{
               first_name: "Mark",
               id: "1234567890",
               name: "Zuckerberg"
             } = body
    end

    test "returns error if sender_psid is invalid" do
      assert {:error, %{error: error}} = FacebookAPI.get_user_data("0000000000")
      assert %{code: 100, type: "GraphMethodException"} = error
    end

    test "returns error if something went wrong" do
      assert {:error, error} = FacebookAPI.get_user_data("invalid")
      assert error == %HTTPoison.Error{}
    end
  end
end
