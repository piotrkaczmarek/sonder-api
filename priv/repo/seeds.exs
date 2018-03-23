# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     SonderApi.Repo.insert!(%SonderApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias SonderApi.Groups
alias SonderApi.Accounts
alias SonderApi.Groups.Group
alias SonderApi.Groups.UserGroup
alias SonderApi.Accounts.User
alias SonderApi.Posts.Post
alias SonderApi.Repo

# fetch first existing user (before running the script create one with your facebook account)
[main_user | tail] = Accounts.list_users
user_1 = Repo.insert!(%User{first_name: "Bob",   facebook_id: "1"})
user_2 = Repo.insert!(%User{first_name: "Susan", facebook_id: "2"})
user_3 = Repo.insert!(%User{first_name: "Mark",  facebook_id: "3"})
user_4 = Repo.insert!(%User{first_name: "Ann",   facebook_id: "4"})
user_5 = Repo.insert!(%User{first_name: "Grace", facebook_id: "5"})

group_1 = Repo.insert!(%Group{size: 3, name: "Wild Cats", owner_id: main_user.id})
group_2 = Repo.insert!(%Group{size: 5, name: "Team ABC", owner_id: user_1.id})
group_3 = Repo.insert!(%Group{size: 5, name: "AwesomePack", owner_id: user_1.id})

Repo.insert!(%Post{body: "Hello world.", group_id: group_1.id, author_id: user_1.id})
Repo.insert!(%Post{body: "Brave new world", group_id: group_1.id, author_id: user_1.id})
Repo.insert!(%Post{body: "Bye old world", group_id: group_1.id, author_id: user_2.id})

Repo.insert!(%UserGroup{user_id: main_user.id, group_id: group_1.id, state: "accepted"})
Repo.insert!(%UserGroup{user_id: main_user.id, group_id: group_2.id, state: "suggested"})
Repo.insert!(%UserGroup{user_id: main_user.id, group_id: group_3.id, state: "accepted"})

Repo.insert!(%UserGroup{user_id: user_1.id, group_id: group_1.id, state: "applied"})
Repo.insert!(%UserGroup{user_id: user_2.id, group_id: group_1.id, state: "applied"})
Repo.insert!(%UserGroup{user_id: user_3.id, group_id: group_1.id, state: "applied"})
Repo.insert!(%UserGroup{user_id: user_4.id, group_id: group_1.id, state: "accepted"})
Repo.insert!(%UserGroup{user_id: user_5.id, group_id: group_1.id, state: "accepted"})

Repo.insert!(%UserGroup{user_id: user_1.id, group_id: group_2.id, state: "accepted"})
Repo.insert!(%UserGroup{user_id: user_2.id, group_id: group_2.id, state: "accepted"})
Repo.insert!(%UserGroup{user_id: user_3.id, group_id: group_2.id, state: "applied"})
Repo.insert!(%UserGroup{user_id: user_4.id, group_id: group_2.id, state: "applied"})
Repo.insert!(%UserGroup{user_id: user_5.id, group_id: group_2.id, state: "applied"})

Repo.insert!(%UserGroup{user_id: user_1.id, group_id: group_3.id, state: "accepted"})
