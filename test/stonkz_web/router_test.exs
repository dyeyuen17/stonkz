defmodule StonkzWeb.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias StonkzWeb.Router

  @opts Router.init([])

  # Create a test with the name "return ok"
  test "returns 200 when calling webhooks endpoints with post" do
    conn = conn(:post, "/webhooks", %{"entry" => %{}})
    conn = Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Success"
  end

  test "returns 200 when calling webhooks endpoints with get" do
    conn = conn(:get, "/webhooks", %{"entry" => %{}})
    conn = Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Success"
  end

  test "returns 200 when calling challenge endpoint" do
    params = %{
      "hub.challenge" => "CHALLENGE",
      "hub.mode" => "subscribe",
      "hub.verify_token" => "VERIFY_TOKEN_12345"
    }

    conn = conn(:get, "/webhooks", params)
    conn = Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "CHALLENGE"
  end

  test "returns 403 when calling challenge endpoint with invalid token" do
    params = %{
      "hub.challenge" => "CHALLENGE",
      "hub.mode" => "subscribe",
      "hub.verify_token" => "INVALID_TOKEN"
    }

    conn = conn(:get, "/webhooks", params)
    conn = Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 403
    assert conn.resp_body == "Forbidden"
  end

  test "returns helth check" do
    conn = conn(:get, "/helth_check")
    conn = Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "GOOD HELTH"
  end

  test "returns 404" do
    conn = conn(:get, "/api")
    conn = Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "Not Found"
  end
end
