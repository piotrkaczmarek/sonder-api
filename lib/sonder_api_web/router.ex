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
    plug CORSPlug, [origin: "http://localhost:4200"]
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

    resources "/parties", SubController, only: [:create]
    get "/parties/suggested", SubController, :suggested
    get "/parties/accepted", SubController, :accepted
    put "/parties/:id/apply", SubController, :apply
    put "/parties/:id/dismiss", SubController, :dismiss
    get "/parties/:id/applicants", SubController, :applicants
    put "/parties/:party_id/applicants/:user_id/accept", SubController, :accept
    put "/parties/:party_id/applicants/:user_id/reject", SubController, :reject
  end
end
