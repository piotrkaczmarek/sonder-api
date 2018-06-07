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

  def render("post.json", %{post: post}) do
    voted = case post.votes do
      [%SonderApi.Posts.Vote{} = vote | _] -> vote.points
      _ -> 0
    end
    %{id: post.id,
      title: post.title,
      body: post.body,
      author: %{id: post.author.id, username: post.author.first_name},
      points: post.points,
      voted: voted,
      commentCount: post.comment_count
    }
  end

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, PostView, "post_with_comment_count.json")}
  end
end
