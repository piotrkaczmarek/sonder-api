defmodule SonderApiWeb.PostControllerTest do
  use SonderApiWeb.ConnCase

  alias SonderApi.Posts
  alias SonderApi.Posts.Tags

  describe "index/0 when authorized" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

  #   test "returns posts from all accepted groups", %{conn: conn, user: current_user} do
  #     user = insert(:user)
  #     group_1 = insert(:group)
  #     group_2 = insert(:group)
  #     group_3 = insert(:group)

  #     insert(:user_group, %{group: group_1, user: current_user, state: "accepted"})
  #     insert(:user_group, %{group: group_2, user: current_user, state: "accepted"})

  #     post_1 = insert(:post, %{group: group_1})
  #     post_2 = insert(:post, %{group: group_1})
  #     post_3 = insert(:post, %{group: group_2})
  #     post_4 = insert(:post, %{group: group_3})
  #     comment_1 = insert(:comment, %{post: post_1})

  #     vote_1 = insert(:vote, %{post: post_1, comment: nil, voter: user})
  #     vote_2 = insert(:vote, %{post: post_1, comment: nil})
  #     vote_3 = insert(:vote, %{post: post_1, comment: comment_1, voter: user})
  #     vote_4 = insert(:vote, %{post: post_2, comment: nil, voter: user})

  #     group_posts = Posts.get_group_posts(%{group_ids: [group_1.id, group_2.id], page: 1, per_page: 100})

  #     assert([post_1.id, post_2.id, post_3.id] == Enum.map(group_posts, fn(x) -> x.id end))
  #     assert([[vote_1.id], [vote_4.id], []] == Enum.map(group_posts, fn(x) -> Enum.map(x.votes, fn(y) -> y.id end) end))
  #   end
  end

  describe "index/1 when authorized" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "returns empty array when there are no posts", %{conn: conn, user: current_user} do
      group = insert(:group)
      insert(:user_group, %{user: current_user, group: group, state: "accepted"})
      conn = get conn, "/api/groups/#{group.id}/posts"
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "index/1 when not authorized" do
    test "returns 401" do
      group = insert(:group)
      conn = get conn, "/api/groups/#{group.id}/posts"
      assert json_response(conn, 401)
    end
  end

  describe "create/1 with tags" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "creates post and tags", %{conn: conn, user: current_user} do
      tag = insert(:tag)
      data = %{
        post: %{title: "title", body: "body"},
        tags: [%{id: nil, name: "test"}, %{id: tag.id, name: tag.name}]
      }
      conn = post conn, post_path(conn, :create), data
      assert json_response(conn, 201)

      assert length(Tags.list_tags) == 2
      assert length(Posts.list_posts) == 1
      assert length(Tags.list_post_tags) == 2
    end
  end
end
