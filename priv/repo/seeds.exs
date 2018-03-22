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

alias SonderApi.Subs
alias SonderApi.Accounts
alias SonderApi.Subs.Sub
alias SonderApi.Subs.UserSub
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

sub_1 = Repo.insert!(%Sub{size: 3, name: "Wild Cats", owner_id: main_user.id})
sub_2 = Repo.insert!(%Sub{size: 5, name: "Team ABC", owner_id: user_1.id})
sub_3 = Repo.insert!(%Sub{size: 5, name: "AwesomePack", owner_id: user_1.id})

Repo.insert!(%Post{body: "Hello world.", sub_id: sub_1.id, author_id: user_1.id})
Repo.insert!(%Post{body: "Brave new world", sub_id: sub_1.id, author_id: user_1.id})
Repo.insert!(%Post{body: "Bye old world", sub_id: sub_1.id, author_id: user_2.id})

Repo.insert!(%UserSub{user_id: main_user.id, sub_id: sub_1.id, state: "accepted"})
Repo.insert!(%UserSub{user_id: main_user.id, sub_id: sub_2.id, state: "suggested"})
Repo.insert!(%UserSub{user_id: main_user.id, sub_id: sub_3.id, state: "accepted"})

Repo.insert!(%UserSub{user_id: user_1.id, sub_id: sub_1.id, state: "applied"})
Repo.insert!(%UserSub{user_id: user_2.id, sub_id: sub_1.id, state: "applied"})
Repo.insert!(%UserSub{user_id: user_3.id, sub_id: sub_1.id, state: "applied"})
Repo.insert!(%UserSub{user_id: user_4.id, sub_id: sub_1.id, state: "accepted"})
Repo.insert!(%UserSub{user_id: user_5.id, sub_id: sub_1.id, state: "accepted"})

Repo.insert!(%UserSub{user_id: user_1.id, sub_id: sub_2.id, state: "accepted"})
Repo.insert!(%UserSub{user_id: user_2.id, sub_id: sub_2.id, state: "accepted"})
Repo.insert!(%UserSub{user_id: user_3.id, sub_id: sub_2.id, state: "applied"})
Repo.insert!(%UserSub{user_id: user_4.id, sub_id: sub_2.id, state: "applied"})
Repo.insert!(%UserSub{user_id: user_5.id, sub_id: sub_2.id, state: "applied"})

Repo.insert!(%UserSub{user_id: user_1.id, sub_id: sub_3.id, state: "accepted"})
