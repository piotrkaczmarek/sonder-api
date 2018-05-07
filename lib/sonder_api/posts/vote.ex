defmodule SonderApi.Posts.Vote do
  use Ecto.Schema
  import Ecto.Changeset
  alias SonderApi.Posts.Vote


  schema "votes" do
    field :points, :integer

    belongs_to :post, SonderApi.Posts.Post
    belongs_to :comment, SonderApi.Posts.Comment
    belongs_to :voter, SonderApi.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%Vote{} = vote, attrs) do
    vote
    |> cast(attrs, [:points, :post_id, :comment_id, :voter_id])
    |> validate_required([:points, :post_id, :voter_id])
  end
end
