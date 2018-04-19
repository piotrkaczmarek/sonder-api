defmodule SonderApi.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias SonderApi.Posts.Post


  schema "posts" do
    field :author_id, :id
    field :group_id, :id
    field :body, :string
    has_many :comments, SonderApi.Posts.Comment

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:body, :group_id, :author_id])
    |> validate_required([:body, :group_id, :author_id])
  end
end
