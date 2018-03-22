defmodule SonderApiWeb.PostController do
  use SonderApiWeb, :controller

  alias SonderApi.Posts
  alias SonderApi.Posts.Post

  action_fallback SonderApiWeb.FallbackController

  def index(conn, %{"sub_id" => sub_id}) do
    with posts <- Posts.get_sub_posts(sub_id)
    do
      render(conn, "index.json", posts: posts)
    end
  end

  def create(conn, %{"sub_id" => sub_id, "post" => post_params}) do
    with current_user_id <- conn.assigns[:current_user].id,
         {:ok, %Post{} = post} <- Posts.create_post(Map.merge(post_params, %{"author_id" => current_user_id, "sub_id" => sub_id}))
    do
      conn
      |> put_status(:created)
      |> render("show.json", post: post)
    end
  end
end
