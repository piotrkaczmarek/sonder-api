defmodule SonderApi.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset
  alias SonderApi.Groups.Group


  schema "groups" do
    field :size, :integer
    field :name, :string

    belongs_to :owner, SonderApi.Accounts.User
    many_to_many :users, SonderApi.Accounts.User, join_through: "user_groups"
    timestamps()
  end

  @doc false
  def changeset(%Group{} = group, attrs) do
    group
    |> cast(attrs, [:name, :owner_id])
    |> validate_required([:name, :owner_id])
  end
end
