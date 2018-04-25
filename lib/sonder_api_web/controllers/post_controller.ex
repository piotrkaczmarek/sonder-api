defmodule SonderApiWeb.PostController do
  use SonderApiWeb, :controller

  alias SonderApi.Posts
  alias SonderApi.Posts.Post
  alias SonderApi.Posts.Comment

  action_fallback SonderApiWeb.FallbackController

  def index(conn, %{"group_id" => group_id}) do
    with posts <- Posts.get_group_posts(group_id)
    do
      render(conn, "index.json", posts: posts)
    end
  end

  def show(conn, %{"post_id" => post_id}) do
    with post <- Posts.get_post_with_comments(%{post_id: post_id})
    do
      render(conn, "show_with_comments.json", post: post)
    end
  end

  def create(conn, %{"group_id" => group_id, "post" => post_params}) do
    with current_user_id <- conn.assigns[:current_user].id,
         {:ok, %Post{} = post} <- Posts.create_post(Map.merge(post_params, %{"author_id" => current_user_id, "group_id" => group_id}))
    do
      conn
      |> put_status(:created)
      |> render("show.json", post: post)
    end
  end

  def create_comment(conn, %{"post_id" => post_id, "comment" => comment_params}) do
    with current_user_id <- conn.assigns[:current_user].id,
         {:ok, %Comment{} = comment } <- Posts.create_comment(Map.merge(comment_params, %{"author_id" => current_user_id, "post_id" => post_id}))
    do
      conn
      |> put_status(:created)
      |> render("show_comment.json", comment: comment)
    end
  end
end
