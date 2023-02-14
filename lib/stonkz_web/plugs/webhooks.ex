defmodule StonkzWeb.Plug.Webhooks do
  @behaviour Plug

  import Plug.Conn
  alias StonkzWeb.Handlers.Events

  # @verify_token Application.compile_env(:stonkz, :verify_token)
  @verify_token "Wuyn0i7P5C/RT4m7l3eGIrLrNHt5PnhMg2ckyjpW4vH5odiZ82yrux1vWsMlOV86"

  @doc false
  def init(opts), do: opts

  @doc false
  def call(conn, _action) do
    handle_request(conn, conn.params)
  end

  defp handle_request(
         conn,
         %{
           "hub.challenge" => hub_challenge,
           "hub.mode" => "subscribe",
           "hub.verify_token" => verify_token
         } = _params
       )
       when verify_token == @verify_token do
    send_resp(conn, 200, hub_challenge)
  end

  defp handle_request(conn, %{"hub.mode" => "subscribe"}) do
    send_resp(conn, 403, "Forbidden")
  end

  defp handle_request(conn, %{"entry" => entry}) do
    IO.inspect(entry)

    Task.start(fn ->
      Events.handle_entry(entry)
    end)

    send_resp(conn, 200, "")
  end

  defp handle_request(conn, _params) do
    send_resp(conn, 200, "")
  end
end
