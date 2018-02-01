defmodule SonderApi.Parties.Party do
  use Ecto.Schema
  import Ecto.Changeset
  alias SonderApi.Parties.Party


  schema "parties" do
    field :size, :integer
    field :name, :string

    many_to_many :users, SonderApi.Accounts.User, join_through: "user_parties"
    timestamps()
  end

  @doc false
  def changeset(%Party{} = party, attrs) do
    party
    |> cast(attrs, [:size, :name])
    |> validate_required([:size, :name])
  end
end
