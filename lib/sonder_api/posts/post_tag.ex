defmodule SonderApi.Posts.PostTag do
  use Ecto.Schema
  import Ecto.Changeset
  alias SonderApi.Posts.PostTag


  schema "post_tags" do
    belongs_to :post, SonderApi.Posts.Post
    belongs_to :tag, SonderApi.Posts.Tag

    timestamps()
  end

  @doc false
  def changeset(%PostTag{} = post_tag, attrs) do
    post_tag
    |> cast(attrs, [:post_id, :tag_id])
    |> validate_required([:post_id, :tag_id])
  end
end
