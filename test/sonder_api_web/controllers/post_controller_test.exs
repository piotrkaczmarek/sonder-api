defmodule SonderApiWeb.PostControllerTest do
  use SonderApiWeb.ConnCase

  alias SonderApi.Posts

  describe "index/1 when authorized" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "returns empty array when there are no posts", %{conn: conn, user: current_user} do
      group = insert(:group)
      insert(:user_group, %{user: current_user, group: group, state: "accepted"})
      conn = get conn, post_path(conn, :index, group.id)
      assert json_response(conn, 200)["data"] == []
    end

    test "return unauthorized when user is not accepted to the group", %{conn: conn, user: current_user} do
      group = insert(:group)
      post = insert(:post, %{group: group})
      conn = get conn, post_path(conn, :index, group.id)
      assert json_response(conn, 401)
    end

    test "returns posts with votes", %{conn: conn, user: current_user} do
      group = insert(:group)
      insert(:user_group, %{user: current_user, group: group, state: "accepted"})
      post_1 = insert(:post, %{group: group})
      post_2 = insert(:post, %{group: group})
      post_3 = insert(:post, %{group: group})

      insert(:vote, %{post: post_1, voter: current_user, comment: nil, points: 1})
      insert(:vote, %{post: post_1, voter: current_user, points: -1})
      insert(:vote, %{post: post_2, voter: current_user, comment: nil, points: -1})

      conn = get conn, post_path(conn, :index, group.id)

      returned_votes = Enum.reduce(json_response(conn,200)["data"], %{}, fn(x, acc) -> Map.put(acc, x["id"], x["voted"]) end)
      assert returned_votes == %{post_1.id => 1, post_2.id => -1, post_3.id => 0}
    end
  end

  describe "index/1 when not authorized" do
    test "returns 401" do
      group = insert(:group)
      conn = get conn, post_path(conn, :index, group.id)
      assert json_response(conn, 401)
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
