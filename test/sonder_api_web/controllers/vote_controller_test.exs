defmodule SonderApiWeb.VoteControllerTest do
  use SonderApiWeb.ConnCase

  alias SonderApi.Posts
  alias SonderApi.Posts.Vote

  describe "post_votes/1" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "returns all user's post votes", %{conn: conn, user: current_user} do
      post_1 = insert(:post)
      insert(:vote, %{post: post_1, voter: current_user, comment: nil})
      post_2 = insert(:post)
      insert(:vote, %{post: post_2, voter: current_user, comment: nil})

      conn = get conn, vote_path(conn, :post_votes)
      post_ids = Enum.map(json_response(conn, 200)["data"], fn x -> [x["postId"], x["commentId"]] end)
      assert post_ids == [[post_1.id, nil], [post_2.id, nil]]
    end
  end

  describe "comment_votes/1" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "returns all user's comment votes for given post", %{conn: conn, user: current_user} do
      post_1 = insert(:post)
      comment_1 = insert(:comment, %{post: post_1})
      insert(:vote, %{post: post_1, voter: current_user, comment: comment_1})
      comment_2 = insert(:comment, %{post: post_1})
      insert(:vote, %{post: post_1, voter: current_user, comment: comment_2})

      conn = get conn, vote_path(conn, :comment_votes, post_1.id)
      post_ids = Enum.map(json_response(conn, 200)["data"], fn x -> [x["postId"], x["commentId"]] end)
      assert post_ids == [[post_1.id, comment_1.id], [post_1.id, comment_2.id]]
    end
  end

  describe "upvote/2 post" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "updates post points", %{conn: conn, user: current_user} do
      group = insert(:group)
      insert(:user_group, %{user: current_user, group: group, state: "accepted"})
      post = insert(:post, %{group: group})
      insert_list(3, :vote, %{post: post, points: 1, comment: nil})
      conn = post conn, vote_path(conn, :upvote, "posts", post.id)
      %{"postId" => post_id } = json_response(conn, 201)["data"]
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
      %{"commentId" => comment_id } = json_response(conn, 201)["data"]
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
      %{"postId" => post_id } = json_response(conn, 201)["data"]
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
      %{"commentId" => comment_id } = json_response(conn, 201)["data"]
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
      %{"postId" => post_id } = json_response(conn, 201)["data"]
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
      %{"commentId" => comment_id } = json_response(conn, 201)["data"]
      assert Posts.get_comment(comment_id).points == 3
    end
  end
end
