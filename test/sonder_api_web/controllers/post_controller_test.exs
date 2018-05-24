defmodule SonderApiWeb.PostControllerTest do
  use SonderApiWeb.ConnCase

  alias SonderApi.Posts

  describe "index/0 when authorized" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "returns posts from all accepted groups", %{conn: conn, user: current_user} do
      user = insert(:user)
      group_1 = insert(:group)
      group_2 = insert(:group)
      group_3 = insert(:group)

      insert(:user_group, %{group: group_1, user: current_user, state: "accepted"})
      insert(:user_group, %{group: group_2, user: current_user, state: "accepted"})

      post_1 = insert(:post, %{group: group_1})
      post_2 = insert(:post, %{group: group_1})
      post_3 = insert(:post, %{group: group_2})
      post_4 = insert(:post, %{group: group_3})
      comment_1 = insert(:comment, %{post: post_1})

      vote_1 = insert(:vote, %{post: post_1, comment: nil, voter: user})
      vote_2 = insert(:vote, %{post: post_1, comment: nil})
      vote_3 = insert(:vote, %{post: post_1, comment: comment_1, voter: user})
      vote_4 = insert(:vote, %{post: post_2, comment: nil, voter: user})

      group_posts = Posts.get_group_posts(%{group_ids: [group_1.id, group_2.id], current_user_id: user.id})

      assert([post_1.id, post_2.id, post_3.id] == Enum.map(group_posts, fn(x) -> x.id end))
      assert([[vote_1.id], [vote_4.id], []] == Enum.map(group_posts, fn(x) -> Enum.map(x.votes, fn(y) -> y.id end) end))
    end
  end

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
end
