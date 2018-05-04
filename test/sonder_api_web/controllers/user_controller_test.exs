defmodule SonderApiWeb.UserControllerTest do
  use SonderApiWeb.ConnCase

  describe "me when authorized" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "it returns current user data", %{conn: conn, user: current_user} do
      conn = get conn, user_path(conn, :me)
      assert json_response(conn, 200)["data"] ==
        %{"firstName" => current_user.first_name, "id" => current_user.id}
    end
  end

  describe "me when unauthorized" do
    test "returns 401", %{conn: conn} do
      conn = get conn, user_path(conn, :me)

      assert json_response(conn, 401)["error"] == "Unauthorized"
    end
  end

  defp create_user_and_authorize(conn) do
    user = insert(:user)
    {:ok, encoded_token, _claims} = SonderApi.Guardian.encode_and_sign(user)
    conn = conn
    |> put_req_header("authorization", encoded_token)
    |> put_req_header("accept", "application/json")
    { :ok, conn: conn, user: user }
  end
end
