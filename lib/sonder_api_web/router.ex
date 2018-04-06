defmodule SonderApiWeb.Router do
  use SonderApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug CORSPlug, [origin: [System.get_env("UI_HOST"), "http://localhost:4200"]]
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

    get "/groups/:group_id/posts", PostController, :index
    post "/groups/:group_id/posts", PostController, :create
  end
end
