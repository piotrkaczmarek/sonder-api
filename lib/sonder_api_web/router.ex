defmodule SonderApiWeb.Router do
  use SonderApiWeb, :router

  alias SonderApi.Groups
  alias SonderApi.Groups.UserGroup
  alias SonderApi.Posts
  alias SonderApi.Posts.Post

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug CORSPlug, [origin: Enum.filter([System.get_env("UI_HOST"), "http://localhost:4200"], & !is_nil(&1))]
    plug :accepts, ["json"]
  end

  defp authenticate_user(conn, _) do
    with [token] <- get_req_header(conn, "authorization"),
         {:ok, user, claims} <- SonderApi.Guardian.resource_from_token(token)
    do
      assign(conn, :current_user, user)
    else
      _ -> handle_unauthorized(conn)
    end
  end

  defp accepted_to_group(conn, _) do
    with current_user_id <- conn.assigns[:current_user].id,
         group_id <- group_id_from_params(conn.params),
         %UserGroup{} = user_group <- Groups.get_user_group(%{user_id: current_user_id, group_id: group_id}),
         "accepted" <- user_group.state
    do
      conn
    else
      _ -> handle_unauthorized(conn)
    end
  end

  defp group_id_from_params(%{"group_id" => group_id}) do
    group_id
  end

  defp group_id_from_params(%{"post_id" => post_id}) do
    with %Post{} = post <- Posts.get_post(post_id)
    do
      post.group_id
    end
  end

  defp handle_unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> halt()
    |> put_view(SonderApiWeb.ErrorView)
    |> render("401.json", %{})
  end

  scope "/", SonderApiWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", SonderApiWeb do
    pipe_through :api

    post "/authenticate", UserController, :authenticate
  end

  scope "/api", SonderApiWeb do
    pipe_through [:api, :authenticate_user]

    get "/profiles/me", UserController, :me

    resources "/groups", GroupController, only: [:create]
    get "/groups/suggested", GroupController, :suggested
    get "/groups/accepted", GroupController, :accepted
    put "/groups/:group_id/apply", GroupController, :apply
    put "/groups/:group_id/dismiss", GroupController, :dismiss
    get "/groups/:group_id/applicants", GroupController, :applicants
    put "/groups/:group_id/applicants/:user_id/accept", GroupController, :accept
    put "/groups/:group_id/applicants/:user_id/reject", GroupController, :reject

    post "/:target_class/:target_id/upvote", VoteController, :upvote
    post "/:target_class/:target_id/downvote", VoteController, :downvote
    post "/:target_class/:target_id/revoke_vote", VoteController, :revoke_vote

    get "/posts", PostController, :index
  end

  scope "/api", SonderApiWeb do
    pipe_through [:api, :authenticate_user, :accepted_to_group]

    get "/groups/:group_id/posts", PostController, :index
    post "/groups/:group_id/posts", PostController, :create

    get "/posts/:post_id", PostController, :show
    get "/posts/:post_id/comments", CommentController, :index
    post "/posts/:post_id/comments", CommentController, :create
  end
end
