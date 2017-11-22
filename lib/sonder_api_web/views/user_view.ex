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
      first_name: user.first_name}
  end

  def render("show_private.json", %{user: user}) do
    %{data: render_one(user, UserView, "user_private.json")}
  end

  def render("user_private.json", %{user: user}) do
    %{id: user.id,
      first_name: user.first_name,
      email: user.email,
      facebook_id: user.facebook_id,
      facebook_access_token: user.facebook_access_token}
  end
end
