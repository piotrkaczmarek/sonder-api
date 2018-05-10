defmodule SonderApiWeb.VoteControllerTest do
  use SonderApiWeb.ConnCase

  alias SonderApi.Posts
  alias SonderApi.Posts.Vote

  describe "upvote/2 post" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "updates post points", %{conn: conn, user: current_user} do
      group = insert(:group)
      insert(:user_group, %{user: current_user, group: group, state: "accepted"})
      post = insert(:post, %{group: group})
      insert_list(3, :vote, %{post: post, points: 1, comment: nil})
      conn = post conn, vote_path(conn, :upvote, "posts", post.id)
      %{"post_id" => post_id } = json_response(conn, 201)["data"]
      assert Posts.get_post(post_id).points == 4
    end
  end

  describe "upvote/2 comment" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "updates comment points", %{conn: conn, user: current_user} do
      group = insert(:group)
      insert(:user_group, %{user: current_user, group: group, state: "accepted"})
      post = insert(:post, %{group: group})
      comment = insert(:comment, %{post: post})
      insert_list(3, :vote, %{post: post, points: 1, comment: comment})

      conn = post conn, vote_path(conn, :upvote, "comments", comment.id)
      %{"comment_id" => comment_id } = json_response(conn, 201)["data"]
      assert Posts.get_comment(comment_id).points == 4
    end
  end

  describe "downvote/2 post" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "updates post points", %{conn: conn, user: current_user} do
      group = insert(:group)
      insert(:user_group, %{user: current_user, group: group, state: "accepted"})
      post = insert(:post, %{group: group})
      insert_list(3, :vote, %{post: post, points: 1, comment: nil})

      conn = post conn, vote_path(conn, :downvote, "posts", post.id)
      %{"post_id" => post_id } = json_response(conn, 201)["data"]
      assert Posts.get_post(post_id).points == 2
    end
  end

  describe "downvote/2 comment" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "updates comment points", %{conn: conn, user: current_user} do
      group = insert(:group)
      insert(:user_group, %{user: current_user, group: group, state: "accepted"})
      post = insert(:post, %{group: group})
      comment = insert(:comment, %{post: post})
      insert_list(3, :vote, %{post: post, points: 1, comment: comment})

      conn = post conn, vote_path(conn, :downvote, "comments", comment.id)
      %{"comment_id" => comment_id } = json_response(conn, 201)["data"]
      assert Posts.get_comment(comment_id).points == 2
    end
  end

  describe "revoke_vote/2 post" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "updates post points", %{conn: conn, user: current_user} do
      group = insert(:group)
      insert(:user_group, %{user: current_user, group: group, state: "accepted"})
      post = insert(:post, %{group: group})
      insert(:vote, %{post: post, points: 1, comment: nil, voter: current_user})
      insert_list(3, :vote, %{post: post, points: 1, comment: nil})

      conn = post conn, vote_path(conn, :revoke_vote, "posts", post.id)
      %{"post_id" => post_id } = json_response(conn, 201)["data"]
      assert Posts.get_post(post_id).points == 3
    end
  end

  describe "revoke_vote/2 comment" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "updates comment points", %{conn: conn, user: current_user} do
      group = insert(:group)
      insert(:user_group, %{user: current_user, group: group, state: "accepted"})
      post = insert(:post, %{group: group})
      comment = insert(:comment, %{post: post})
      insert(:vote, %{post: post, points: 1, comment: comment, voter: current_user})
      insert_list(3, :vote, %{post: post, points: 1, comment: comment})

      conn = post conn, vote_path(conn, :revoke_vote, "comments", comment.id)
      %{"comment_id" => comment_id } = json_response(conn, 201)["data"]
      assert Posts.get_comment(comment_id).points == 3
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
