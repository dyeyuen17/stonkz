defmodule StonkzWeb.Services.FacebookTest do
  use ExUnit.Case, async: true
  alias StonkzWeb.Services.Facebook

  describe "process_request_url/1" do
    test "returns prepended with base url" do
      Facebook.start()
      assert Facebook.process_request_url("/me") == "https://graph.facebook.com/v16.0/me"
    end
  end

  describe "process_request_headers/1" do
    test "returns new headers with default header" do
      assert Facebook.process_request_headers([{"Accept", "application/json"}]) ==
               [{"Content-Type", "application/json"}, {"Accept", "application/json"}]
    end
  end

  describe "process_request_body/1" do
    test "returns Jason encoded payload" do
      payload = Facebook.process_request_body(%{message: "MESSAGE"})

      assert is_binary(payload)
      assert payload == "{\"message\":\"MESSAGE\"}"
    end
  end

  describe "process_response_body/1" do
    test "returns map response body with atom keys" do
      payload = Facebook.process_response_body("{\"message\":\"MESSAGE\"}")

      assert is_map(payload)
      assert payload == %{message: "MESSAGE"}
    end
  end
end
