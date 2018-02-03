defmodule SonderApiWeb.UserController do
  use SonderApiWeb, :controller

  alias SonderApi.Accounts
  alias SonderApi.Accounts.User
  alias SonderApi.Accounts.FacebookClient
  alias SonderApi.Guardian

  action_fallback SonderApiWeb.FallbackController

  # def index(conn, _params) do
  #   users = Accounts.list_users()
  #   render(conn, "index.json", users: users)
  # end

  # def create(conn, %{"user" => user_params}) do
  #   with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
  #     conn
  #     |> put_status(:created)
  #     |> put_resp_header("location", user_path(conn, :show, user))
  #     |> render("show_private.json", user: user)
  #   end
  # end

  # def show(conn, %{"id" => id}) do
  #   user = Accounts.get_user!(id)
  #   render(conn, "show.json", user: user)
  # end

  # def update(conn, %{"id" => id, "user" => user_params}) do
  #   user = Accounts.get_user!(id)

  #   with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
  #     render(conn, "show.json", user: user)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   user = Accounts.get_user!(id)
  #   with {:ok, %User{}} <- Accounts.delete_user(user) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end

  def authenticate(conn, %{"access_token" => access_token}) do
    with {:ok, data} <- FacebookClient.fetch_user_data(access_token),
         {:ok, user} <- Accounts.get_or_create_user(data),
         {:ok, token, claims} <- Guardian.encode_and_sign(user)
    do
      render(conn, "token.json", token: token)
    end
  end
end
