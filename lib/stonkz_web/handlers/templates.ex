defmodule StonkzWeb.Handlers.Templates do
  @spec text_template(String.t(), String.t(), String.t()) :: map()
  def text_template(sender_psid, message, messaging_type \\ "RESPONSE") do
    %{
      messaging_type: messaging_type,
      message: %{
        text: message
      },
      recipient: %{
        id: sender_psid
      }
    }
  end

  @spec buttons_template(String.t(), String.t(), list(), String.t()) :: map()
  def buttons_template(sender_psid, message, buttons, messaging_type \\ "RESPONSE") do
    %{
      messaging_type: messaging_type,
      message: %{
        attachment: %{
          type: "template",
          payload: %{
            template_type: "button",
            text: message,
            buttons: buttons
          }
        }
      },
      recipient: %{
        id: sender_psid
      }
    }
  end

  @spec button_template(String.t(), String.t(), String.t()) :: map()
  def button_template(payload_type, title, button_type \\ "postback") do
    %{
      payload: payload_type,
      type: button_type,
      title: title
    }
  end

  @spec url_button_template(String.t(), String.t()) :: map()
  def url_button_template(url, title) do
    %{
      type: "web_url",
      url: url,
      title: title
    }
  end

  @spec generic_template(String.t(), list(map())) :: map()
  def generic_template(sender_psid, elements) do
    %{
      message: %{
        attachment: %{
          type: "template",
          payload: %{
            template_type: "generic",
            elements: elements
          }
        }
      },
      recipient: %{id: sender_psid}
    }
  end

  @spec generic_element_template(map(), map(), map()) :: map()
  def generic_element_template(element_data, default_action, buttons) do
    %{
      title: element_data[:title],
      image_url: element_data[:image_url],
      subtitle: element_data[:subtitle],
      default_action: default_action,
      buttons: buttons
    }
  end

  @spec generic_default_action_template(String.t(), String.t(), String.t()) :: map()
  def generic_default_action_template(url, type \\ "web_url", ratio \\ "full") do
    %{
      type: type,
      url: url,
      webview_height_ratio: ratio
    }
  end

  @spec sender_action_template(String.t(), String.t()) :: map()
  def sender_action_template(sender_psid, sender_action) do
    %{
      sender_action: sender_action,
      recipient: %{
        id: sender_psid
      }
    }
  end
end
