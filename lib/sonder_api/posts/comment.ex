defmodule SonderApi.Posts.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias SonderApi.Posts.Comment


  schema "comments" do
    field :author_id, :id
    field :body, :string
    field :parent_ids, {:array, :integer}
    belongs_to :post, SonderApi.Posts.Post

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:body, :post_id, :author_id])
    |> validate_required([:body, :post_id, :author_id])
  end
end
