defmodule SonderApi.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: SonderApi.Repo

  def user_factory do
    %SonderApi.Accounts.User{
      first_name: "Jane",
      email: sequence(:email, &"email-#{&1}@example.com"),
      auth_token: "123456789"
    }
  end

  def group_factory do
    %SonderApi.Groups.Group{
      size: 20,
      name: sequence(:name, &"group #{&1}"),
      owner: build(:user)
    }
  end

  def user_group_factory do
    %SonderApi.Groups.UserGroup{
      user: build(:user),
      group: build(:group),
      state: sequence(:role, ["suggested", "applied", "dismissed", "accepted", "rejected"])
    }
  end

  def post_factory do
    %SonderApi.Posts.Post{
      title: Faker.Lorem.Shakespeare.as_you_like_it,
      body: Faker.Lorem.Shakespeare.as_you_like_it,
      author: build(:user),
      group: build(:group)
    }
  end

  def comment_factory do
    %SonderApi.Posts.Comment{
      body: Faker.Lorem.Shakespeare.as_you_like_it,
      parent_ids: [],
      author: build(:user),
      post: build(:post)
    }
  end

  def vote_factory do
    %SonderApi.Posts.Vote{
      points: 1,
      post: build(:post),
      comment: build(:comment),
      voter: build(:user)
    }
  end
end
