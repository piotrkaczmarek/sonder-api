defmodule SonderApiWeb.ControllerHelpers do
  use Phoenix.ConnTest
  import SonderApiWeb.Router.Helpers
  import SonderApi.Factory

  def create_user_and_authorize(conn) do
    user = insert(:user)
    {:ok, encoded_token, _claims} = SonderApi.Guardian.encode_and_sign(user)
    conn = conn
    |> put_req_header("authorization", encoded_token)
    |> put_req_header("accept", "application/json")
    { :ok, conn: conn, user: user }
  end
end
