defmodule SonderApi.Groups.State do
  use Exnumerator,
    values: ["suggested", "applied", "dismissed", "accepted", "rejected"]
end

defmodule SonderApi.Groups.UserGroup do
  use Ecto.Schema
  import Ecto.Changeset
  alias SonderApi.Groups.UserGroup


  schema "user_groups" do
    field :user_id, :id
    field :group_id, :id
    field :state, SonderApi.Groups.State

    timestamps()
  end

  @doc false
  def changeset(%UserGroup{} = user_group, attrs) do
    user_group
    |> cast(attrs, [:user_id, :group_id, :state])
    |> validate_required([:user_id, :group_id, :state])
    |> unique_constraint(:group_id, [name: :index_user_groups_uniqueness])
  end
end
