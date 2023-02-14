defmodule StonkzWeb.Services.FacebookAPI do
  @access_token Application.compile_env(:stonkz, [:fb, :access_token])
  @facebook Application.compile_env(:stonkz, [:services, :facebook])

  def send_response([payload | the_rest] = payloads)
      when is_list(payloads) and length(payloads) > 0 do
    [send_response(payload) | send_response(the_rest)]
  end

  def send_response(payload) when is_map(payload) do
    case @facebook.post("/me/messages?access_token=#{@access_token}", payload, []) do
      {:ok, %{body: body, status_code: 200}} ->
        {:ok, body}

      {:ok, %{body: body}} ->
        {:error, body}

      {:error, error} ->
        {:error, error}
    end
  end

  def send_response(_), do: :ok

  def get_user_data(sender_psid) do
    case @facebook.get("/#{sender_psid}?fields=name,first_name&access_token=#{@access_token}") do
      {:ok, %{body: body, status_code: 200}} ->
        {:ok, body}

      {:ok, %{body: body}} ->
        {:error, body}

      {:error, error} ->
        {:error, error}
    end
  end
end
