defmodule StonkzWeb.Handlers.EventsTest do
  use ExUnit.Case, async: true

  alias StonkzWeb.Handlers.Events

  describe "handle_entry/1" do
    test "handles entry for Get started, recipient_id should match sender_psid" do
      sender_psid = "1234567890"

      entry = [
        %{
          "messaging" => [
            %{
              "postback" => %{
                "payload" => "GET_STARTED"
              },
              "sender" => %{"id" => sender_psid}
            }
          ]
        }
      ]

      assert [{:ok, %{recipient_id: recipient_id}} | _] = Events.handle_entry(entry)
      assert sender_psid == recipient_id
    end

    test "handles entry for Get started, should return error" do
      sender_psid = "0000000000"

      entry = [
        %{
          "messaging" => [
            %{
              "postback" => %{
                "payload" => "GET_STARTED"
              },
              "sender" => %{"id" => sender_psid}
            }
          ]
        }
      ]

      assert [{:error, %{error: %{code: 100}}} | _] = Events.handle_entry(entry)
    end

    test "handles entry for Start over, recipient_id should match sender_psid" do
      sender_psid = "1234567890"

      entry = [
        %{
          "messaging" => [
            %{
              "postback" => %{
                "payload" => "START_OVER"
              },
              "sender" => %{"id" => sender_psid}
            }
          ]
        }
      ]

      :ets.insert(:user_cache, {sender_psid, %{name: "Mark Zuckerberg"}})

      assert [{:ok, %{recipient_id: recipient_id}} | _] = Events.handle_entry(entry)
      assert sender_psid == recipient_id
    end

    test "handles entry for Crypto name search postback, recipient_id should match sender_psid" do
      sender_psid = "1234567890"

      entry = [
        %{
          "messaging" => [
            %{
              "postback" => %{
                "payload" => "NAME_SEARCH",
                "title" => "Search by name"
              },
              "sender" => %{"id" => sender_psid}
            }
          ]
        }
      ]

      assert {:ok, %{recipient_id: recipient_id}} = Events.handle_entry(entry)
      assert sender_psid == recipient_id
    end

    test "handles entry for Crypto ID search postback, recipient_id should match sender_psid" do
      sender_psid = "1234567890"

      entry = [
        %{
          "messaging" => [
            %{
              "postback" => %{
                "payload" => "ID_SEARCH",
                "title" => "Search by ID"
              },
              "sender" => %{"id" => sender_psid}
            }
          ]
        }
      ]

      assert {:ok, %{recipient_id: recipient_id}} = Events.handle_entry(entry)
      assert sender_psid == recipient_id
    end

    test "handles entry for user input, recipient_id should match sender_psid" do
      sender_psid = "1234567890"

      entry = [
        %{
          "messaging" => [
            %{
              "message" => %{
                "text" => "Dogecoin"
              },
              "sender" => %{"id" => sender_psid}
            }
          ]
        }
      ]

      :ets.insert(:user_cache, {sender_psid, %{search_type: "name"}})

      assert {:ok, %{recipient_id: recipient_id}} = Events.handle_entry(entry)
      assert sender_psid == recipient_id
    end

    test "handles entry for invalid user input, recipient_id should match sender_psid" do
      sender_psid = "1234567890"

      entry = [
        %{
          "messaging" => [
            %{
              "message" => %{
                "text" => "Dyeycoin"
              },
              "sender" => %{"id" => sender_psid}
            }
          ]
        }
      ]

      :ets.insert(:user_cache, {sender_psid, %{search_type: "name"}})

      assert {:ok, %{recipient_id: recipient_id}} = Events.handle_entry(entry)
      assert sender_psid == recipient_id
    end

    test "handles entry with unexpected error while searching coin name, recipient_id should match sender_psid" do
      sender_psid = "1234567890"

      entry = [
        %{
          "messaging" => [
            %{
              "message" => %{
                "text" => "Errorcoin"
              },
              "sender" => %{"id" => sender_psid}
            }
          ]
        }
      ]

      :ets.insert(:user_cache, {sender_psid, %{search_type: "Name"}})

      assert {:ok, %{recipient_id: recipient_id}} = Events.handle_entry(entry)
      assert sender_psid == recipient_id
    end

    test "handles entry for user search for crypto by id, recipient_id should match sender_psid" do
      sender_psid = "1234567890"

      entry = [
        %{
          "messaging" => [
            %{
              "message" => %{
                "text" => "dogecoin"
              },
              "sender" => %{"id" => sender_psid}
            }
          ]
        }
      ]

      :ets.insert(:user_cache, {sender_psid, %{search_type: "ID"}})

      assert {:ok, %{recipient_id: recipient_id}} = Events.handle_entry(entry)
      assert sender_psid == recipient_id
    end

    test "handles entry with unexpected error, recipient_id should match sender_psid" do
      sender_psid = "1234567890"

      entry = [
        %{
          "messaging" => [
            %{
              "message" => %{
                "text" => "errorcoin"
              },
              "sender" => %{"id" => sender_psid}
            }
          ]
        }
      ]

      :ets.insert(:user_cache, {sender_psid, %{search_type: "ID"}})

      assert {:ok, %{recipient_id: recipient_id}} = Events.handle_entry(entry)
      assert sender_psid == recipient_id
    end

    test "handles entry for history button postback, recipient_id should match sender_psid" do
      sender_psid = "1234567890"

      entry = [
        %{
          "messaging" => [
            %{
              "postback" => %{
                "payload" => "COIN_HISTORY:dogecoin",
                "title" => "Show History"
              },
              "sender" => %{"id" => sender_psid}
            }
          ]
        }
      ]

      assert [{:ok, %{recipient_id: recipient_id}} | _] = Events.handle_entry(entry)
      assert sender_psid == recipient_id
    end

    test "handles entry for invalid history button postback, recipient_id should match sender_psid" do
      sender_psid = "1234567890"

      entry = [
        %{
          "messaging" => [
            %{
              "postback" => %{
                "payload" => "COIN_HISTORY:errorcoin",
                "title" => "Show History"
              },
              "sender" => %{"id" => sender_psid}
            }
          ]
        }
      ]

      assert {:ok, %{recipient_id: recipient_id}} = Events.handle_entry(entry)
      assert sender_psid == recipient_id
    end

    test "handles entry for any other user input, recipient_id should match sender_psid" do
      sender_psid = "1234567890"

      entry = [
        %{
          "messaging" => [
            %{
              "sender" => %{"id" => sender_psid}
            }
          ]
        }
      ]

      assert {:ok, %{recipient_id: recipient_id}} = Events.handle_entry(entry)
      assert sender_psid == recipient_id
    end
  end
end
