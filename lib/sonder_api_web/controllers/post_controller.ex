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
         posts <- Posts.get_group_posts(%{group_id: group_id})
    do
      render(conn, "index.json", posts: posts)
    end
  end

  def index(conn, %{"page" => page, "perPage" => per_page, "tags" => tags}) do
    with current_user_id <- conn.assigns[:current_user].id,
         group_ids <- Groups.list_accepted_group_ids(current_user_id),
         page <- Posts.get_group_posts(%{group_ids: group_ids, page: page, per_page: per_page})
    do
      render(conn, "paginated_index.json", posts: page.entries, page: page)
    end
  end

  def show(conn, %{"post_id" => post_id}) do
    with current_user_id <- conn.assigns[:current_user].id,
         %Post{} = post <- Posts.get_post(%{post_id: post_id})
    do
      render(conn, "show.json", post: post)
    end
  end

  def create(conn, %{"post" => post_params, "tags" => tags}) do
    with current_user_id <- conn.assigns[:current_user].id,
         post_attrs <- Map.merge(post_params, %{"author_id" => current_user_id}),
         {:ok, %Post{} = post} <- Posts.create_post_with_tags(%{post: post_attrs, tags: tags})
    do
      conn
      |> put_status(:created)
      |> render("show.json", post: post)
    end
  end
end
