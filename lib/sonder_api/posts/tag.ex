defmodule SonderApi.Posts.Tag do
  use Ecto.Schema
  import Ecto.Changeset
  alias SonderApi.Posts.Tag


  schema "tags" do
    field :name, :string

    many_to_many :groups, SonderApi.Posts.Post, join_through: "post_tags"

    timestamps()
  end

  @doc false
  def changeset(%Tag{} = tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
