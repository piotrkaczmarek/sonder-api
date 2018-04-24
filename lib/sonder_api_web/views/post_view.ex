defmodule SonderApiWeb.PostView do
  use SonderApiWeb, :view
  alias SonderApiWeb.PostView
  alias SonderApiWeb.CommentView
  alias SonderApi.Posts

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, PostView, "post.json")}
  end

  def render("show_with_comments.json", %{post: post}) do
    %{data: render_one(post, PostView, "post_with_comments.json")}
  end

  def render("post.json", %{post: post}) do
    %{id: post.id,
      title: post.title,
      body: post.body
    }
  end

  def render("post_with_comments.json", %{post: post}) do
    %{id: post.id,
      title: post.title,
      body: post.body,
      authorId: post.author_id,
      comments: render_many(post.comments, CommentView, "show.json")
    }
  end
end
