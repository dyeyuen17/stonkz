defmodule StonkzWeb.Services.Facebook do
  @moduledoc """
    this custom module wraps the functionalities and callbacks provided by HTTPoison.
  """

  use HTTPoison.Base

  @url "https://graph.facebook.com/v16.0"

  def process_request_url(url), do: @url <> url

  def process_request_headers(headers) do
    [{"Content-Type", "application/json"} | headers]
  end

  def process_request_body(body) do
    Jason.encode!(body)
  end

  def process_response_body(body) do
    Jason.decode!(body, keys: :atoms)
  end
end
