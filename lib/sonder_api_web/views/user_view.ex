defmodule SonderApiWeb.UserView do
  use SonderApiWeb, :view
  alias SonderApiWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      firstName: user.first_name}
  end

  def render("show_private.json", %{user: user}) do
    %{data: render_one(user, UserView, "user_private.json")}
  end

  def render("token.json", %{token: token}) do
    %{auth_token: token}
  end

  def render("user_private.json", %{user: user}) do
    %{id: user.id,
      firstName: user.first_name,
      email: user.email,
      facebookId: user.facebook_id}
  end
end
