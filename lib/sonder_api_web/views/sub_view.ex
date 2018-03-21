defmodule SonderApiWeb.SubView do
  use SonderApiWeb, :view
  alias SonderApiWeb.SubView
  alias SonderApiWeb.UserView
  alias SonderApi.Subs

  def render("index.json", %{subs: subs}) do
    %{data: render_many(subs, SubView, "sub.json")}
  end

  def render("show.json", %{sub: sub}) do
    %{data: render_one(sub, SubView, "sub.json")}
  end

  def render("sub.json", %{sub: sub}) do
    %{id: sub.id,
      name: sub.name,
      size: sub.size,
      members: render_many(Subs.list_members(sub.id), SonderApiWeb.UserView, "user.json")
    }
  end

  def render("people.json", %{people: people}) do
    %{data: render_many(people, UserView, "user.json")}
  end
end
