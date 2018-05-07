defmodule SonderApi.PostsTest do
  use SonderApi.DataCase

  alias SonderApi.Posts

  describe "get_group_posts/2" do
    test "returns only posts votes of current user" do
      user = insert(:user)
      group = insert(:group)
      post_1 = insert(:post, %{group: group})
      post_2 = insert(:post, %{group: group})
      post_3 = insert(:post, %{group: group})
      comment_1 = insert(:comment, %{post: post_1})

      vote_1 = insert(:vote, %{post: post_1, comment: nil, voter: user})
      vote_2 = insert(:vote, %{post: post_1, comment: nil})
      vote_3 = insert(:vote, %{post: post_1, comment: comment_1, voter: user})
      vote_4 = insert(:vote, %{post: post_2, comment: nil, voter: user})

      group_posts = Posts.get_group_posts(%{group_id: group.id, current_user_id: user.id})

      assert([post_1.id, post_2.id, post_3.id] == Enum.map(group_posts, fn(x) -> x.id end))
      assert([[vote_1.id], [vote_4.id], []] == Enum.map(group_posts, fn(x) -> Enum.map(x.votes, fn(y) -> y.id end) end))
    end
  end

  describe "get_post_with_comments/1 when post and comments exist" do
    test "returns post with comments" do
      post = insert(:post)
      comment_1 = insert(:comment, %{post: post})
      comment_2 = insert(:comment, %{post: post})
      post = Posts.get_post_with_comments(%{post_id: post.id})
      assert([comment_1.id, comment_2.id] == Enum.map(post.comments, fn(x) -> x.id end))
    end
  end

  describe "votes" do
    alias SonderApi.Posts.Vote
  end
end
