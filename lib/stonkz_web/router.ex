defmodule StonkzWeb.Router do
  use Plug.Router

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  post("/webhooks", to: StonkzWeb.Plug.Webhooks)
  get("/webhooks", to: StonkzWeb.Plug.Webhooks)

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
