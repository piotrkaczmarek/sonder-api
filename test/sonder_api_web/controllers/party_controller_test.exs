defmodule SonderApiWeb.SubControllerTest do
  use SonderApiWeb.ConnCase

  alias SonderApi.Subs
  alias SonderApi.Subs.Sub
  alias SonderApi.Accounts

  @create_attrs %{size: 42}
  @update_attrs %{size: 43}
  @invalid_attrs %{size: nil}

  def fixture(:sub) do
    {:ok, sub} = Subs.create_sub(@create_attrs)
    sub
  end

  def fixture(:user) do
    token = "123456"
    {:ok, user } = Accounts.create_user(%{first_name: "Bob", email: "test@example.com", auth_token: token, facebook_id: "1234"})
    { user, token }
  end

  describe "index when authorized" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "returns empty array when there are no parties", %{conn: conn} do
      conn = get conn, sub_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end

    test "returns all parties with users", %{conn: conn} do
      sub_1 = create_sub()
      sub_2 = create_sub()
      user_1 = create_user(%{email: "email1@example.com", auth_token: "abc", facebook_id: "123", first_name: "Bob"})
      user_2 = create_user(%{email: "email2@example.com", auth_token: "bcd", facebook_id: "234", first_name: "Susan"})

      create_user_sub(%{user_id: user_1.id, sub_id: sub_1.id, state: "accepted"})
      create_user_sub(%{user_id: user_1.id, sub_id: sub_2.id, state: "accepted"})
      create_user_sub(%{user_id: user_2.id, sub_id: sub_1.id, state: "accepted"})

      conn = get conn, sub_path(conn, :index)

      expected_response = [
        %{"id" => sub_1.id,
          "size" => sub_1.size,
          "members" => [%{"id" => user_1.id, "first_name" => user_1.first_name}, %{"id" => user_2.id, "first_name" => user_2.first_name}]},
        %{"id" => sub_2.id,
          "size" => sub_2.size,
          "members" => [%{"id" => user_1.id, "first_name" => user_1.first_name}]}
      ]

      assert json_response(conn, 200)["data"] == expected_response
    end
  end

  describe "index when not authorized" do
    test "returns 401", %{conn: conn} do
      conn = get conn, sub_path(conn, :index)

      assert json_response(conn, 401)["error"] == "Unauthorized"
    end
  end

  describe "request" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "creates user_sub with state 'requested'", %{conn: conn} do
      sub = create_sub()

      conn = put(conn, "/api/parties/#{sub.id}/request")
      assert conn.status, "204"

      [user_sub] = Subs.list_user_parties
      assert conn.assigns[:current_user].id == user_sub.user_id
      assert user_sub.state == "requested"
    end
  end

  describe "dismiss" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "creates user_sub with state 'dismissed'", %{conn: conn} do
      sub = create_sub()

      conn = put(conn, "/api/parties/#{sub.id}/dismiss")
      assert conn.status, "204"

      [user_sub] = Subs.list_user_parties
      assert conn.assigns[:current_user].id == user_sub.user_id
      assert user_sub.state == "dismissed"
    end
  end
  # describe "create sub" do
  #   test "renders sub when data is valid", %{conn: conn} do
  #     conn = post conn, sub_path(conn, :create), sub: @create_attrs
  #     assert %{"id" => id} = json_response(conn, 201)["data"]

  #     conn = get conn, sub_path(conn, :show, id)
  #     assert json_response(conn, 200)["data"] == %{
  #       "id" => id,
  #       "size" => 42}
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post conn, sub_path(conn, :create), sub: @invalid_attrs
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "update sub" do
  #   setup [:create_sub]

  #   test "renders sub when data is valid", %{conn: conn, sub: %Sub{id: id} = sub} do
  #     conn = put conn, sub_path(conn, :update, sub), sub: @update_attrs
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get conn, sub_path(conn, :show, id)
  #     assert json_response(conn, 200)["data"] == %{
  #       "id" => id,
  #       "size" => 43}
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, sub: sub} do
  #     conn = put conn, sub_path(conn, :update, sub), sub: @invalid_attrs
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete sub" do
  #   setup [:create_sub]

  #   test "deletes chosen sub", %{conn: conn, sub: sub} do
  #     conn = delete conn, sub_path(conn, :delete, sub)
  #     assert response(conn, 204)
  #     assert_error_sent 404, fn ->
  #       get conn, sub_path(conn, :show, sub)
  #     end
  #   end
  # end

  def create_sub(attrs \\ %{}) do
    {:ok, sub} =
      attrs
      |> Enum.into(%{size: 4})
      |> Subs.create_sub()

    sub
  end

  defp create_user(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{email: "email@example.com", auth_token: "some auth_token", facebook_id: "some facebook_id", first_name: "some first_name"})
      |> SonderApi.Accounts.create_user()

    user
  end

  defp create_user_sub(attrs \\ %{}) do
    {:ok, user_sub} =
      attrs
      |> Subs.create_user_sub()

    user_sub
  end

  defp create_user_and_authorize(conn) do
    { user, token } = fixture(:user)
    conn = conn
    |> put_req_header("accesstoken", token)
    |> put_req_header("accept", "application/json")
    { :ok, conn: conn }
  end
end
