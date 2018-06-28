defmodule SonderApiWeb.PostController do
  use SonderApiWeb, :controller

  alias SonderApi.Posts
  alias SonderApi.Posts.Post
  alias SonderApi.Posts.Comment
  alias SonderApi.Groups
  alias SonderApi.Groups.Group

  action_fallback SonderApiWeb.FallbackController

  def index(conn, %{"group_id" => group_id}) do
    with current_user_id <- conn.assigns[:current_user].id,
         posts <- Posts.get_group_posts(%{group_id: group_id, current_user_id: current_user_id}),
         posts <- Posts.append_comment_counts(%{posts: posts})
    do
      render(conn, "index.json", posts: posts)
    end
  end

  def index(conn, %{}) do
    with current_user_id <- conn.assigns[:current_user].id,
         group_ids <- Groups.list_accepted_group_ids(current_user_id),
         posts <- Posts.get_group_posts(%{group_ids: group_ids, current_user_id: current_user_id}),
         posts <- Posts.append_comment_counts(%{posts: posts})
    do
      render(conn, "index.json", posts: posts)
    end
  end

  def show(conn, %{"post_id" => post_id}) do
    with current_user_id <- conn.assigns[:current_user].id,
         %Post{} = post <- Posts.get_post(%{post_id: post_id, current_user_id: current_user_id}),
         post <- Posts.append_comment_count(post)
    do
      render(conn, "show.json", post: post)
    end
  end

  def create(conn, %{"group_id" => group_id, "post" => post_params}) do
    with current_user_id <- conn.assigns[:current_user].id,
         %Group{} = group <- Groups.get_group!(group_id),
         {:ok, %Post{} = post} <- Posts.create_post(Map.merge(post_params, %{"author_id" => current_user_id, "group_id" => group_id})),
         post <- Map.merge(post,%{
           comment_count: 0,
           author: %{id: current_user_id, first_name: conn.assigns[:current_user].first_name},
           group: %{id: group.id, name: group.name}
         })
    do
      conn
      |> put_status(:created)
      |> render("show.json", post: post)
    end
  end
end
