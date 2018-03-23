defmodule SonderApiWeb.GroupControllerTest do
  use SonderApiWeb.ConnCase

  alias SonderApi.Groups
  alias SonderApi.Groups.Group
  alias SonderApi.Accounts

  @create_attrs %{size: 42}
  @update_attrs %{size: 43}
  @invalid_attrs %{size: nil}

  def fixture(:group) do
    {:ok, group} = Groups.create_group(@create_attrs)
    group
  end

  def fixture(:user) do
    token = "123456"
    {:ok, user } = Accounts.create_user(%{first_name: "Bob", email: "test@example.com", auth_token: token, facebook_id: "1234"})
    { user, token }
  end

  describe "index when authorized" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "returns empty array when there are no groups", %{conn: conn} do
      conn = get conn, group_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end

    test "returns all groups with users", %{conn: conn} do
      group_1 = create_group()
      group_2 = create_group()
      user_1 = create_user(%{email: "email1@example.com", auth_token: "abc", facebook_id: "123", first_name: "Bob"})
      user_2 = create_user(%{email: "email2@example.com", auth_token: "bcd", facebook_id: "234", first_name: "Susan"})

      create_user_group(%{user_id: user_1.id, group_id: group_1.id, state: "accepted"})
      create_user_group(%{user_id: user_1.id, group_id: group_2.id, state: "accepted"})
      create_user_group(%{user_id: user_2.id, group_id: group_1.id, state: "accepted"})

      conn = get conn, group_path(conn, :index)

      expected_response = [
        %{"id" => group_1.id,
          "size" => group_1.size,
          "members" => [%{"id" => user_1.id, "first_name" => user_1.first_name}, %{"id" => user_2.id, "first_name" => user_2.first_name}]},
        %{"id" => group_2.id,
          "size" => group_2.size,
          "members" => [%{"id" => user_1.id, "first_name" => user_1.first_name}]}
      ]

      assert json_response(conn, 200)["data"] == expected_response
    end
  end

  describe "index when not authorized" do
    test "returns 401", %{conn: conn} do
      conn = get conn, group_path(conn, :index)

      assert json_response(conn, 401)["error"] == "Unauthorized"
    end
  end

  describe "request" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "creates user_group with state 'requested'", %{conn: conn} do
      group = create_group()

      conn = put(conn, "/api/groups/#{group.id}/request")
      assert conn.status, "204"

      [user_group] = Groups.list_user_groups
      assert conn.assigns[:current_user].id == user_group.user_id
      assert user_group.state == "requested"
    end
  end

  describe "dismiss" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "creates user_group with state 'dismissed'", %{conn: conn} do
      group = create_group()

      conn = put(conn, "/api/groups/#{group.id}/dismiss")
      assert conn.status, "204"

      [user_group] = Groups.list_user_groups
      assert conn.assigns[:current_user].id == user_group.user_id
      assert user_group.state == "dismissed"
    end
  end
  # describe "create group" do
  #   test "renders group when data is valid", %{conn: conn} do
  #     conn = post conn, group_path(conn, :create), group: @create_attrs
  #     assert %{"id" => id} = json_response(conn, 201)["data"]

  #     conn = get conn, group_path(conn, :show, id)
  #     assert json_response(conn, 200)["data"] == %{
  #       "id" => id,
  #       "size" => 42}
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post conn, group_path(conn, :create), group: @invalid_attrs
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "update group" do
  #   setup [:create_group]

  #   test "renders group when data is valid", %{conn: conn, group: %Group{id: id} = group} do
  #     conn = put conn, group_path(conn, :update, group), group: @update_attrs
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get conn, group_path(conn, :show, id)
  #     assert json_response(conn, 200)["data"] == %{
  #       "id" => id,
  #       "size" => 43}
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, group: group} do
  #     conn = put conn, group_path(conn, :update, group), group: @invalid_attrs
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete group" do
  #   setup [:create_group]

  #   test "deletes chosen group", %{conn: conn, group: group} do
  #     conn = delete conn, group_path(conn, :delete, group)
  #     assert response(conn, 204)
  #     assert_error_sent 404, fn ->
  #       get conn, group_path(conn, :show, group)
  #     end
  #   end
  # end

  def create_group(attrs \\ %{}) do
    {:ok, group} =
      attrs
      |> Enum.into(%{size: 4})
      |> Groups.create_group()

    group
  end

  defp create_user(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{email: "email@example.com", auth_token: "some auth_token", facebook_id: "some facebook_id", first_name: "some first_name"})
      |> SonderApi.Accounts.create_user()

    user
  end

  defp create_user_group(attrs \\ %{}) do
    {:ok, user_group} =
      attrs
      |> Groups.create_user_group()

    user_group
  end

  defp create_user_and_authorize(conn) do
    { user, token } = fixture(:user)
    conn = conn
    |> put_req_header("accesstoken", token)
    |> put_req_header("accept", "application/json")
    { :ok, conn: conn }
  end
end
