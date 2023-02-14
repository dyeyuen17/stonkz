defmodule StonkzWeb.Plug.WebhooksTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias StonkzWeb.Plug.Webhooks

  @opts Webhooks.init([])

  test "handles webhooks with entry payload" do
    conn = conn(:get, "/webhooks", %{"entry" => %{}})
    conn = Webhooks.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Success"
  end

  test "handles challenge webhooks, returns 200" do
    params = %{
      "hub.challenge" => "CHALLENGE",
      "hub.mode" => "subscribe",
      "hub.verify_token" => "VERIFY_TOKEN_12345"
    }

    conn = conn(:get, "/webhooks", params)
    conn = Webhooks.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "CHALLENGE"
  end

  test "handles challenge webhooks with invalid token, returns 403" do
    params = %{
      "hub.challenge" => "CHALLENGE",
      "hub.mode" => "subscribe",
      "hub.verify_token" => "INVALID_TOKEN"
    }

    conn = conn(:get, "/webhooks", params)
    conn = Webhooks.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 403
    assert conn.resp_body == "Forbidden"
  end

  test "handles other incoming webhooks requests, returns 200" do
    conn = conn(:get, "/webhooks", %{})
    conn = Webhooks.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == ""
  end
end
