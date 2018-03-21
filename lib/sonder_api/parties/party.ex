defmodule SonderApi.Subs.Sub do
  use Ecto.Schema
  import Ecto.Changeset
  alias SonderApi.Subs.Sub


  schema "parties" do
    field :size, :integer
    field :name, :string
    field :owner_id, :id

    many_to_many :users, SonderApi.Accounts.User, join_through: "user_parties"
    timestamps()
  end

  @doc false
  def changeset(%Sub{} = sub, attrs) do
    sub
    |> cast(attrs, [:size, :name, :owner_id])
    |> validate_required([:size, :name, :owner_id])
  end
end
