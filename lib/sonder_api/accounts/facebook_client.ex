defmodule SonderApi.Accounts.FacebookClient do
  alias SonderApi.Accounts.FacebookClient

  def fetch_user_data(access_token) do
    request_params(access_token)
    |> request
    |> Poison.decode
    |> map_response(access_token)
  end

  defp request(query) do
    Tesla.get("https://graph.facebook.com/v2.9/me", query: query).body
  end

  defp request_params(access_token) do
    [
      access_token: access_token,
      fields: requested_fields
    ]
  end

  defp requested_fields do
    ["id", "first_name", "age_range", "cover", "email", "picture"]
    |> Enum.join(",")
  end

  defp map_response({ :ok, data }, access_token) do
    { :ok, %{
        facebook_id: data["id"],
        first_name: data["first_name"],
        email: data["email"]
      }
    }
  end
end
