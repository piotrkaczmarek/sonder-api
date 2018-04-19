defmodule SonderApi.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: SonderApi.Repo

  def user_factory do
    %SonderApi.Accounts.User{
      first_name: "Jane",
      email: sequence(:email, &"email-#{&1}@example.com")
    }
  end

  def group_factory do
    %SonderApi.Groups.Group{
      size: 20,
      name: sequence(:name, &"group #{&1}"),
      owner_id: 1
    }
  end

  def user_group_factory do
    %SonderApi.Groups.UserGroup{
      user_id: 1,
      group_id: 1,
      state: sequence(:role, ["suggested", "applied", "dismissed", "accepted", "rejected"])
    }
  end

  def post_factory do
    title = sequence(:title, &"Use ExMachina! (Part #{&1})")
    %SonderApi.Posts.Post{
      body: title,
      author_id: 1,
      group_id: 1
    }
  end

  def comment_factory do
    %SonderApi.Posts.Comment{
      body: "It's great!",
      parent_ids: [],
      author_id: 1,
      post: build(:post)
    }
  end
end
