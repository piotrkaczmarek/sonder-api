defmodule SonderApiWeb.GroupView do
  use SonderApiWeb, :view
  alias SonderApiWeb.GroupView
  alias SonderApiWeb.UserView
  alias SonderApi.Groups

  def render("index.json", %{groups: groups}) do
    %{data: render_many(groups, GroupView, "group.json")}
  end

  def render("show.json", %{group: group}) do
    %{data: render_one(group, GroupView, "group.json")}
  end

  def render("group.json", %{group: group}) do
    %{id: group.id,
      name: group.name,
      size: group.size,
      members: render_many(Groups.list_members(group.id), SonderApiWeb.UserView, "user.json")
    }
  end

  def render("people.json", %{people: people}) do
    %{data: render_many(people, UserView, "user.json")}
  end
end
