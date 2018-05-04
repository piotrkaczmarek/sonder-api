defmodule SonderApi.Posts.Vote do
  use Ecto.Schema
  import Ecto.Changeset
  alias SonderApi.Posts.Vote


  schema "votes" do
    field :points, :integer
    field :target_class, :string
    field :target_id, :integer
    field :voter_id, :integer

    timestamps()
  end

  @doc false
  def changeset(%Vote{} = vote, attrs) do
    vote
    |> cast(attrs, [:points, :target_id, :target_class, :voter_id])
    |> validate_required([:points, :target_id, :target_class, :voter_id])
  end
end
