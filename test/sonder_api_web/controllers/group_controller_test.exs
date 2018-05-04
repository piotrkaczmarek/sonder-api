defmodule SonderApiWeb.GroupControllerTest do
  use SonderApiWeb.ConnCase

  alias SonderApi.Groups

  describe "suggested when authorized" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "returns empty array when there are no groups", %{conn: conn} do
      conn = get conn, group_path(conn, :suggested)
      assert json_response(conn, 200)["data"] == []
    end

    test "returns accepted groups with users", %{conn: conn, user: current_user} do
      group_1 = insert(:group)
      group_2 = insert(:group)
      insert(:user_group, %{user: current_user, group: group_1, state: "suggested"})
      insert(:user_group, %{user: current_user, group: group_2, state: "suggested"})

      user_1 = insert(:user)
      user_2 = insert(:user)
      insert(:user_group, %{user: user_1, group: group_1, state: "accepted"})
      insert(:user_group, %{user: user_1, group: group_2, state: "accepted"})
      insert(:user_group, %{user: user_2, group: group_1, state: "accepted"})
      conn = get conn, group_path(conn, :suggested)

      expected_response = [
        %{"id" => group_1.id,
          "name" => group_1.name,
          "size" => group_1.size,
          "members" => [%{"id" => user_1.id, "firstName" => user_1.first_name}, %{"id" => user_2.id, "firstName" => user_2.first_name}]},
        %{"id" => group_2.id,
          "name" => group_2.name,
          "size" => group_2.size,
          "members" => [%{"id" => user_1.id, "firstName" => user_1.first_name}]}
      ]

      assert json_response(conn, 200)["data"] == expected_response
    end
  end

  describe "suggested when not authorized" do
    test "returns 401", %{conn: conn} do
      conn = get conn, group_path(conn, :suggested)

      assert json_response(conn, 401)["error"] == "Unauthorized"
    end
  end

  describe "apply" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "creates user_group with state 'requested'", %{conn: conn} do
      group = insert(:group)

      conn = put(conn, "/api/groups/#{group.id}/apply")
      assert conn.status, "204"

      [user_group] = Groups.list_user_groups
      assert conn.assigns[:current_user].id == user_group.user_id
      assert user_group.state == "applied"
    end
  end

  describe "dismiss" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "creates user_group with state 'dismissed'", %{conn: conn} do
      group = insert(:group)

      conn = put(conn, "/api/groups/#{group.id}/dismiss")
      assert conn.status, "204"

      [user_group] = Groups.list_user_groups
      assert conn.assigns[:current_user].id == user_group.user_id
      assert user_group.state == "dismissed"
    end
  end

  describe "create group" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "creates and returns group when data is valid", %{conn: conn} do
      conn = post conn, group_path(conn, :create), group: %{name: "Test Group"}
      assert %{"id" => _id, "name" => "Test Group"} = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, group_path(conn, :create), group: %{}
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

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

  defp create_user_and_authorize(conn) do
    user = insert(:user)
    {:ok, encoded_token, _claims} = SonderApi.Guardian.encode_and_sign(user)
    conn = conn
    |> put_req_header("authorization", encoded_token)
    |> put_req_header("accept", "application/json")
    { :ok, conn: conn, user: user }
  end
end
