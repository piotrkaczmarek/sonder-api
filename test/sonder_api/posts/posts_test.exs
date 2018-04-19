defmodule SonderApi.PostsTest do
  use SonderApi.DataCase

  alias SonderApi.Posts

  describe "get_post_with_comments/1 when post and comments exist" do
    alias SonderApi.Posts.Post

    test "returns post with comments" do
      user = insert(:user)
      group = insert(:group, %{owner_id: user.id})
      post = insert(:post, %{group_id: group.id, author_id: user.id})
      comment_1 = insert(:comment, %{post: post, author_id: user.id})
      comment_2 = insert(:comment, %{post: post, author_id: user.id})
      post = Posts.get_post_with_comments(%{post_id: post.id})
      assert([comment_1, comment_2] = post.comments)
    end
  end
end
