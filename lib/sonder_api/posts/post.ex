defmodule SonderApi.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias SonderApi.Posts.Post


  schema "posts" do
    field :author_id, :id
    field :sub_id, :id
    field :body, :string

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:body, :sub_id, :author_id])
    |> validate_required([:body, :sub_id, :author_id])
  end
end
