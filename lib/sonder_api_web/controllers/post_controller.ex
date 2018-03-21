defmodule SonderApiWeb.PostController do
  use SonderApiWeb, :controller

  alias SonderApi.Posts
  alias SonderApi.Posts.Post

  action_fallback SonderApiWeb.FallbackController

  def index(conn, %{"id" => sub_id}) do
    with posts <- Posts.get_sub_posts(sub_id)
    do
      render(conn, "index.json", posts: posts)
    end
  end
end
