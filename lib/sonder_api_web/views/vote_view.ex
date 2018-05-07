defmodule SonderApiWeb.VoteView do
  use SonderApiWeb, :view
  alias SonderApiWeb.VoteView

  def render("index.json", %{votes: votes}) do
    %{data: render_many(votes, VoteView, "vote.json")}
  end

  def render("show.json", %{vote: vote}) do
    %{data: render_one(vote, VoteView, "vote.json")}
  end

  def render("vote.json", %{vote: vote}) do
    %{id: vote.id,
      points: vote.points,
      post_id: vote.post_id,
      comment_id: vote.comment_id,
      voter_id: vote.voter_id}
  end
end
