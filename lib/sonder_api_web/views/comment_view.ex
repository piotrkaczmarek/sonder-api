defmodule SonderApiWeb.CommentView do
  use SonderApiWeb, :view
  alias SonderApiWeb.CommentView
  alias SonderApi.Comments

  def render("show.json", %{comment: comment}) do
    %{id: comment.id,
      body: comment.body,
      authorId: comment.author_id,
      parentIds: comment.parent_ids
    }
  end
end
