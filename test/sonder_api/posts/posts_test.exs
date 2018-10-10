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

    test "returns posts from all groups" do
      user = insert(:user)
      group_1 = insert(:group)
      group_2 = insert(:group)
      group_3 = insert(:group)

      post_1 = insert(:post, %{group: group_1})
      post_2 = insert(:post, %{group: group_2})
      post_3 = insert(:post, %{group: group_3})
      comment_1 = insert(:comment, %{post: post_1})

      vote_1 = insert(:vote, %{post: post_1, comment: nil, voter: user})
      vote_2 = insert(:vote, %{post: post_1, comment: nil})
      vote_3 = insert(:vote, %{post: post_1, comment: comment_1, voter: user})
      vote_4 = insert(:vote, %{post: post_2, comment: nil, voter: user})

      group_posts = Posts.get_group_posts(%{group_ids: [group_1.id, group_2.id], current_user_id: user.id})

      assert([post_1.id, post_2.id] == Enum.map(group_posts, fn(x) -> x.id end))
      assert([[vote_1.id], [vote_4.id]] == Enum.map(group_posts, fn(x) -> Enum.map(x.votes, fn(y) -> y.id end) end))
    end
  end

  describe "get_comment_count/1" do
    test "returns count for a single post" do
      group = insert(:group)
      post_1 = insert(:post, %{group: group})
      comment_1 = insert(:comment, %{post: post_1})
      comment_2 = insert(:comment, %{post: post_1})

      assert(2 == Posts.get_comment_count(%{post_id: post_1.id}))
    end
  end

  describe "get_comment_counts/1" do
    test "returns counts only for multiple posts" do
      group = insert(:group)
      post_1 = insert(:post, %{group: group})
      post_2 = insert(:post, %{group: group})
      post_3 = insert(:post, %{group: group})
      comment_1 = insert(:comment, %{post: post_1})
      comment_2 = insert(:comment, %{post: post_1})
      comment_2 = insert(:comment, %{post: post_2})

      assert(%{post_1.id => 2, post_2.id => 1, post_3.id => 0} == Posts.get_comment_counts(%{post_ids: [post_1.id, post_2.id, post_3.id]}))
    end
  end

  describe "votes" do
    alias SonderApi.Posts.Vote
  end

  # describe "comments" do
  #   alias SonderApi.Posts.Comment

  #   test "list_comments/0 returns all comments" do
  #     comment = comment_fixture()
  #     assert Posts.list_comments() == [comment]
  #   end

  #   test "get_comment!/1 returns the comment with given id" do
  #     comment = comment_fixture()
  #     assert Posts.get_comment!(comment.id) == comment
  #   end

  #   test "create_comment/1 with valid data creates a comment" do
  #     assert {:ok, %Comment{} = comment} = Posts.create_comment(@valid_attrs)
  #   end

  #   test "create_comment/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Posts.create_comment(@invalid_attrs)
  #   end

  #   test "update_comment/2 with valid data updates the comment" do
  #     comment = comment_fixture()
  #     assert {:ok, comment} = Posts.update_comment(comment, @update_attrs)
  #     assert %Comment{} = comment
  #   end

  #   test "update_comment/2 with invalid data returns error changeset" do
  #     comment = comment_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Posts.update_comment(comment, @invalid_attrs)
  #     assert comment == Posts.get_comment!(comment.id)
  #   end

  #   test "delete_comment/1 deletes the comment" do
  #     comment = comment_fixture()
  #     assert {:ok, %Comment{}} = Posts.delete_comment(comment)
  #     assert_raise Ecto.NoResultsError, fn -> Posts.get_comment!(comment.id) end
  #   end

  #   test "change_comment/1 returns a comment changeset" do
  #     comment = comment_fixture()
  #     assert %Ecto.Changeset{} = Posts.change_comment(comment)
  #   end
  # end
end
