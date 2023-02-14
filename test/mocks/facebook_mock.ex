defmodule Stonkz.Mocks.FacebookMock do
  def post(
        "/me/messages?access_token=FB_ACCESS_TOKEN_12345",
        %{
          recipient: %{id: "1234567890"},
          sender_action: _
        },
        _
      ) do
    {
      :ok,
      %{
        body: %{
          recipient_id: "1234567890"
        },
        status_code: 200
      }
    }
  end

  def post(
        "/me/messages?access_token=FB_ACCESS_TOKEN_12345",
        %{
          message: %{text: _text},
          messaging_type: "RESPONSE",
          recipient: %{id: "1234567890"}
        },
        _
      ) do
    {
      :ok,
      %{
        body: %{
          message_id:
            "m_PRiDFRXQadFoWUMYlfxOgTLPOMzNFVHR1OyhZ2FG14_wOF1TIlw_B3gTYCiLYXtI3RTkFejN5O38rZmhtYy_A",
          recipient_id: "1234567890"
        },
        status_code: 200
      }
    }
  end

  def post(
        "/me/messages?access_token=FB_ACCESS_TOKEN_12345",
        %{
          message: %{
            attachment: %{
              payload: %{
                buttons: _buttons,
                template_type: "button",
                text: _text
              },
              type: "template"
            }
          },
          messaging_type: "RESPONSE",
          recipient: %{id: "1234567890"}
        },
        _
      ) do
    {
      :ok,
      %{
        body: %{
          message_id:
            "m_PRiDFRXQadFoWUMYlfxOgTLPOMzNFVHR1OyhZ2FG14_wOF1TIlw_B3gTYCiLYXtI3RTkFejN5O38rZmhtYy_A",
          recipient_id: "1234567890"
        },
        status_code: 200
      }
    }
  end

  def post(
        "/me/messages?access_token=FB_ACCESS_TOKEN_12345",
        %{
          message: %{
            attachment: %{
              payload: %{
                elements: [
                  %{
                    buttons: _buttons,
                    default_action: _default_action,
                    image_url: _image_url,
                    subtitle: _subtitle,
                    title: _title
                  }
                  | _
                ],
                template_type: "generic"
              },
              type: "template"
            }
          },
          recipient: %{id: "1234567890"}
        },
        _
      ) do
    {
      :ok,
      %{
        body: %{
          message_id:
            "m_PRiDFRXQadFoWUMYlfxOgTLPOMzNFVHR1OyhZ2FG14_wOF1TIlw_B3gTYCiLYXtI3RTkFejN5O38rZmhtYy_A",
          recipient_id: "1234567890"
        },
        status_code: 200
      }
    }
  end

  def post(
        "/me/messages?access_token=FB_ACCESS_TOKEN_12345",
        %{recipient: %{id: "0000000000"}},
        _
      ) do
    {
      :ok,
      %{
        body: %{
          error: %{
            code: 100,
            error_subcode: 2_018_001,
            fbtrace_id: "AE-ZkBk9FvEOCOG9YOIUIcp",
            message: "(#100) No matching user found",
            type: "OAuthException"
          }
        },
        status_code: 400
      }
    }
  end

  def post(_, _, _) do
    {:error, %HTTPoison.Error{}}
  end

  def get("/1234567890?fields=name,first_name&access_token=FB_ACCESS_TOKEN_12345") do
    {:ok,
     %{
       body: %{
         first_name: "Mark",
         id: "1234567890",
         name: "Zuckerberg"
       },
       status_code: 200
     }}
  end

  def get("/0000000000?fields=name,first_name&access_token=FB_ACCESS_TOKEN_12345") do
    {:ok,
     %{
       body: %{
         error: %{
           code: 100,
           error_subcode: 33,
           fbtrace_id: "A72lzKnwDJC132R5OLZrX6u",
           message: "Unsupported get request. Object with ID '0000000000' does not exist,...",
           type: "GraphMethodException"
         }
       },
       status_code: 400
     }}
  end

  def get(_) do
    {:error, %HTTPoison.Error{}}
  end
end
