defmodule SonderApiWeb.PostViewTest do
  use SonderApiWeb.ConnCase, async: true

  alias SonderApi.Posts
  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  describe "post.json when post has a group" do
    test "renders with group" do
      post = insert(:post)
      |> Posts.append_comment_count
      rendered = render(SonderApiWeb.PostView, "post.json", %{ post: post })
      assert rendered.group.id == post.group.id
    end
  end

  describe "post.json when post does not have a group" do
    test "renders without group" do
      post = insert(:post, %{group: nil})
      |> Posts.append_comment_count
      rendered = render(SonderApiWeb.PostView, "post.json", %{ post: post })
      assert Map.has_key?(rendered, :group) == false
    end
  end
end
