defmodule SonderApiWeb.VoteController do
  use SonderApiWeb, :controller

  alias SonderApi.Posts
  alias SonderApi.Posts.Vote
  alias SonderApi.Posts.Post
  alias SonderApi.Posts.Comment

  action_fallback SonderApiWeb.FallbackController

  def upvote(conn, %{"target_class" => "posts", "target_id" => post_id}) do
    with %Post{} = post <- Posts.get_post(post_id),
         {:ok, %Vote{} = vote} <- Posts.upsert_vote(%{voter_id: conn.assigns[:current_user].id,
                                                      post_id: post.id,
                                                      points: 1}),
         {:ok, %Post{}} <- Posts.update_post_points(post)
    do
      conn
      |> put_status(:created)
      |> render("show.json", vote: vote)
    end
  end

  def upvote(conn, %{"target_class" => "comments", "target_id" => comment_id}) do
    with %Comment{} = comment <- Posts.get_comment(comment_id),
         {:ok, %Vote{} = vote} <- Posts.upsert_vote(%{voter_id: conn.assigns[:current_user].id,
                                                      post_id: comment.post_id,
                                                      comment_id: comment.id,
                                                      points: 1}),
         {:ok, %Comment{}} <- Posts.update_comment_points(comment)
    do
      conn
      |> put_status(:created)
      |> render("show.json", vote: vote)
    end
  end

  def downvote(conn, %{"target_class" => "posts", "target_id" => post_id}) do
    with %Post{} = post <- Posts.get_post(post_id),
         {:ok, %Vote{} = vote} <- Posts.upsert_vote(%{voter_id: conn.assigns[:current_user].id,
                                                      post_id: post.id,
                                                      points: -1}),
         {:ok, %Post{}} <- Posts.update_post_points(post)
    do
      conn
      |> put_status(:created)
      |> render("show.json", vote: vote)
    end
  end

  def downvote(conn, %{"target_class" => "comments", "target_id" => comment_id}) do
    with %Comment{} = comment <- Posts.get_comment(comment_id),
         {:ok, %Vote{} = vote} <- Posts.upsert_vote(%{voter_id: conn.assigns[:current_user].id, post_id: comment.post_id, comment_id: comment.id, points: -1}),
         {:ok, %Comment{}} <- Posts.update_comment_points(comment)
    do
      conn
      |> put_status(:created)
      |> render("show.json", vote: vote)
    end
  end

  def revoke_vote(conn, %{"target_class" => "posts", "target_id" => post_id}) do
    with %Post{} = post <- Posts.get_post(post_id),
         {:ok, %Vote{} = vote} <- Posts.upsert_vote(%{voter_id: conn.assigns[:current_user].id,
                                                      post_id: post.id,
                                                      points: 0}),
         {:ok, %Post{}} <- Posts.update_post_points(post)
    do
      conn
      |> put_status(:created)
      |> render("show.json", vote: vote)
    end
  end

  def revoke_vote(conn, %{"target_class" => "comments", "target_id" => comment_id}) do
    with %Comment{} = comment <- Posts.get_comment(comment_id),
         {:ok, %Vote{} = vote} <- Posts.upsert_vote(%{voter_id: conn.assigns[:current_user].id,
                                                      post_id: comment.post_id,
                                                      comment_id: comment.id,
                                                      points: 0}),
         {:ok, %Comment{}} <- Posts.update_comment_points(comment)
    do
      conn
      |> put_status(:created)
      |> render("show.json", vote: vote)
    end
  end
end
