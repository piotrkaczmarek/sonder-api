defmodule SonderApiWeb.CommentView do
  use SonderApiWeb, :view
  alias SonderApiWeb.CommentView

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    voted = case comment.votes do
      [%SonderApi.Posts.Vote{} = vote | _] -> vote.points
      _ -> 0
    end
    %{id: comment.id,
      body: comment.body,
      author: %{id: comment.author.id, username: comment.author.first_name},
      parentIds: comment.parent_ids,
      points: comment.points,
      voted: voted
    }
  end
end
