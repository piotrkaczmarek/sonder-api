defmodule SonderApiWeb.PartyView do
  use SonderApiWeb, :view
  alias SonderApiWeb.PartyView

  def render("index.json", %{parties: parties}) do
    %{data: render_many(parties, PartyView, "party.json")}
  end

  def render("show.json", %{party: party}) do
    %{data: render_one(party, PartyView, "party.json")}
  end

  def render("party.json", %{party: party}) do
    %{id: party.id,
      size: party.size}
  end
end
