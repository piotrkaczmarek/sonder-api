defmodule SonderApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias SonderApi.Accounts.User


  schema "users" do
    field :email, :string
    field :facebook_access_token, :string
    field :facebook_id, :string
    field :first_name, :string

    many_to_many :parties, SonderApi.Parties.Party, join_through: "user_parties"
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:first_name, :email, :facebook_id, :facebook_access_token])
    |> validate_required([:first_name, :facebook_id, :facebook_access_token])
    |> unique_constraint(:email)
    |> unique_constraint(:facebook_id)
  end
end
