defmodule SonderApi.PostsTest do
  use SonderApi.DataCase

  alias SonderApi.Posts

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
