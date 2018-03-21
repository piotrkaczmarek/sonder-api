defmodule SonderApi.Subs.State do
  use Exnumerator,
    values: ["suggested", "applied", "dismissed", "accepted", "rejected"]
end

defmodule SonderApi.Subs.UserSub do
  use Ecto.Schema
  import Ecto.Changeset
  alias SonderApi.Subs.UserSub


  schema "user_parties" do
    field :user_id, :id
    field :sub_id, :id
    field :state, SonderApi.Subs.State

    timestamps()
  end

  @doc false
  def changeset(%UserSub{} = user_sub, attrs) do
    user_sub
    |> cast(attrs, [:user_id, :sub_id, :state])
    |> validate_required([:user_id, :sub_id, :state])
    |> unique_constraint(:sub_id, [name: :index_user_parties_uniqueness])
  end
end
