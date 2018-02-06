defmodule SonderApiWeb.PartyController do
  use SonderApiWeb, :controller

  alias SonderApi.Parties
  alias SonderApi.Parties.Party
  alias SonderApi.Parties.UserParty

  action_fallback SonderApiWeb.FallbackController

  def index(conn, _params) do
    parties = Parties.list_parties()
    render(conn, "index.json", parties: parties)
  end

  def apply(conn, %{"id" => party_id}) do
    attributes = %{user_id: conn.assigns[:current_user].id, party_id: party_id, state: "applied"}
    with {:ok, %UserParty{}} <- Parties.upsert_user_party(attributes) do
      send_resp(conn, :no_content, "")
    end
  end

  def dismiss(conn, %{"id" => party_id}) do
    attributes = %{user_id: conn.assigns[:current_user].id, party_id: party_id, state: "dismissed"}
    with {:ok, %UserParty{}} <- Parties.upsert_user_party(attributes) do
      send_resp(conn, :no_content, "")
    end
  end

  def create(conn, %{"party" => party_params}) do
    with {:ok, %Party{} = party} <- Parties.create_party(party_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", party_path(conn, :show, party))
      |> render("show.json", party: party)
    end
  end

  # def show(conn, %{"id" => id}) do
  #   party = Parties.get_party!(id)
  #   render(conn, "show.json", party: party)
  # end

  # def update(conn, %{"id" => id, "party" => party_params}) do
  #   party = Parties.get_party!(id)

  #   with {:ok, %Party{} = party} <- Parties.update_party(party, party_params) do
  #     render(conn, "show.json", party: party)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   party = Parties.get_party!(id)
  #   with {:ok, %Party{}} <- Parties.delete_party(party) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
