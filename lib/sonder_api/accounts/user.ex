defmodule SonderApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias SonderApi.Accounts.User


  schema "users" do
    field :email, :string
    field :auth_token, :string
    field :facebook_id, :string
    field :first_name, :string

    has_many :posts, SonderApi.Posts.Post, foreign_key: "author_id"
    has_many :comments, SonderApi.Posts.Comment, foreign_key: "author_id"
    has_many :owned_groups, SonderApi.Groups.Group, foreign_key: "owner_id"
    has_many :votes, SonderApi.Posts.Vote, foreign_key: "voter_id"
    many_to_many :groups, SonderApi.Groups.Group, join_through: "user_groups"
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:first_name, :email, :facebook_id, :auth_token])
    |> validate_required([:first_name, :facebook_id])
    |> unique_constraint(:email)
    |> unique_constraint(:facebook_id)
  end
end
