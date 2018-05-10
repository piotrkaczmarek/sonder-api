defmodule SonderApiWeb.CommentController do
  use SonderApiWeb, :controller

  alias SonderApi.Posts
  alias SonderApi.Posts.Comment
  alias SonderApi.Posts.Post

  action_fallback SonderApiWeb.FallbackController

  def index(conn, %{"post_id" => post_id}) do
    with current_user_id <- conn.assigns[:current_user].id,
         comments <- Posts.get_comments(%{post_id: post_id, current_user_id: current_user_id})
    do
      render(conn, "index.json", comments: comments)
    end
  end

  def create(conn, %{"post_id" => post_id, "comment" => comment_params}) do
    with current_user_id <- conn.assigns[:current_user].id,
         %Post{} = post <- Posts.get_post(post_id),
         {:ok, %Comment{} = comment } <- Posts.create_comment(Map.merge(comment_params, %{"author_id" => current_user_id, "post_id" => post.id}))
    do
      conn
      |> put_status(:created)
      |> render("show.json", comment: comment)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Posts.get_comment!(id)
    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Posts.get_comment!(id)

    with {:ok, %Comment{} = comment} <- Posts.update_comment(comment, comment_params) do
      render(conn, "show.json", comment: comment)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Posts.get_comment!(id)
    with {:ok, %Comment{}} <- Posts.delete_comment(comment) do
      send_resp(conn, :no_content, "")
    end
  end
end
