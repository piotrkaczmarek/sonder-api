defmodule SonderApi.Posts.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias SonderApi.Posts.Comment


  schema "comments" do
    field :body, :string
    field :parent_ids, {:array, :integer}
    field :points, :integer

    belongs_to :author, SonderApi.Accounts.User
    belongs_to :post, SonderApi.Posts.Post
    has_many :votes, SonderApi.Posts.Vote

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:body, :post_id, :author_id, :parent_ids, :points])
    |> validate_required([:body, :post_id, :author_id, :parent_ids])
  end
end
