defmodule SonderApiWeb.SubView do
  use SonderApiWeb, :view
  alias SonderApiWeb.SubView
  alias SonderApiWeb.UserView
  alias SonderApi.Subs

  def render("index.json", %{parties: parties}) do
    %{data: render_many(parties, SubView, "party.json")}
  end

  def render("show.json", %{party: party}) do
    %{data: render_one(party, SubView, "party.json")}
  end

  def render("party.json", %{party: party}) do
    %{id: party.id,
      name: party.name,
      size: party.size,
      members: render_many(Subs.list_members(party.id), SonderApiWeb.UserView, "user.json")
    }
  end

  def render("people.json", %{people: people}) do
    %{data: render_many(people, UserView, "user.json")}
  end
end
