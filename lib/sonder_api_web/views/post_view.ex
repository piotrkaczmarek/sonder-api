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

  def render("show_comment.json", %{comment: comment}) do
    %{data: render_one(comment, CommentView, "show.json")}
  end

  def render("show_with_comments.json", %{post: post}) do
    %{data: render_one(post, PostView, "post_with_comments.json")}
  end

  def render("post.json", %{post: post}) do
    voted = case post.votes do
      [%SonderApi.Posts.Vote{} = vote | _] -> vote.points
      _ -> 0
    end
    %{id: post.id,
      title: post.title,
      body: post.body,
      voted: voted
    }
  end

  def render("post_with_comments.json", %{post: post}) do
    voted = case post.votes do
      [%SonderApi.Posts.Vote{} = vote | _] -> vote.points
      _ -> 0
    end
    %{id: post.id,
      title: post.title,
      body: post.body,
      authorId: post.author_id,
      voted: voted,
      comments: render_many(post.comments, CommentView, "show.json")
    }
  end
end
