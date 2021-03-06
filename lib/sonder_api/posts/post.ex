defmodule SonderApi.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias SonderApi.Posts.Post


  schema "posts" do
    field :title, :string
    field :body, :string
    field :points, :integer

    belongs_to :group, SonderApi.Groups.Group
    belongs_to :author, SonderApi.Accounts.User
    has_many :comments, SonderApi.Posts.Comment
    has_many :votes, SonderApi.Posts.Vote

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:body, :title, :group_id, :author_id, :points])
    |> validate_required([:title, :author_id])
  end
end
