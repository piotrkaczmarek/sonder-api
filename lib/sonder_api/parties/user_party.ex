defmodule SonderApi.Subs.State do
  use Exnumerator,
    values: ["suggested", "applied", "dismissed", "accepted", "rejected"]
end

defmodule SonderApi.Subs.UserParty do
  use Ecto.Schema
  import Ecto.Changeset
  alias SonderApi.Subs.UserParty


  schema "user_parties" do
    field :user_id, :id
    field :party_id, :id
    field :state, SonderApi.Subs.State

    timestamps()
  end

  @doc false
  def changeset(%UserParty{} = user_party, attrs) do
    user_party
    |> cast(attrs, [:user_id, :party_id, :state])
    |> validate_required([:user_id, :party_id, :state])
    |> unique_constraint(:party_id, [name: :index_user_parties_uniqueness])
  end
end
