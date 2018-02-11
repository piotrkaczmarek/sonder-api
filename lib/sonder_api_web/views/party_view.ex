defmodule SonderApiWeb.PartyView do
  use SonderApiWeb, :view
  alias SonderApiWeb.PartyView
  alias SonderApiWeb.UserView
  alias SonderApi.Parties

  def render("index.json", %{parties: parties}) do
    %{data: render_many(parties, PartyView, "party.json")}
  end

  def render("show.json", %{party: party}) do
    %{data: render_one(party, PartyView, "party.json")}
  end

  def render("party.json", %{party: party}) do
    %{id: party.id,
      name: party.name,
      size: party.size,
      members: render_many(Parties.list_members(party.id), SonderApiWeb.UserView, "user.json")
    }
  end

  def render("people.json", %{people: people}) do
    %{data: render_many(people, UserView, "user.json")}
  end
end
