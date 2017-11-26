defmodule SonderApi.Parties.State do
  use Exnumerator,
    values: ["requested", "dismissed", "accepted", "rejected"]
end

defmodule SonderApi.Parties.UserParty do
  use Ecto.Schema
  import Ecto.Changeset
  alias SonderApi.Parties.UserParty


  schema "user_parties" do
    field :user_id, :id
    field :party_id, :id
    field :state, SonderApi.Parties.State

    timestamps()
  end

  @doc false
  def changeset(%UserParty{} = user_party, attrs) do
    user_party
    |> cast(attrs, [:user_id, :party_id, :state])
    |> validate_required([:user_id, :party_id, :state])
  end
end
