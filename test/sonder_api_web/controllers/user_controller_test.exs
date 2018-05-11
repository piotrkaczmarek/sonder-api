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
end
