defmodule SonderApiWeb.TagController do
  use SonderApiWeb, :controller

  alias SonderApi.Posts
  alias SonderApi.Posts.Tags
  alias SonderApi.Posts.Tag

  action_fallback SonderApiWeb.FallbackController

  def index(conn, %{}) do
    tags = Tags.list_tags()
    render(conn, "index.json", tags: tags)
  end

  # def create(conn, %{"tag" => tag_params}) do
  #   with {:ok, %Tag{} = tag} <- Posts.create_tag(tag_params)
  #   do
  #     conn
  #     |> put_status(:created)
  #     |> render("show.json", tag: tag)
  #   end
  # end
end
