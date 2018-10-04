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

import SonderApi.Factory

# fetch first existing user or create one using config var
main_user = case Accounts.list_users do
    [%User{} = existing_user | tail] -> existing_user
    [] -> insert(:user, %{first_name: "Piotr", facebook_id: Application.fetch_env!(:plug, :facebook_id)})
end

user_1 = insert(:user, %{first_name: "Bob"})
user_2 = insert(:user, %{first_name: "Susan"})
user_3 = insert(:user, %{first_name: "Mark"})
user_4 = insert(:user, %{first_name: "Ann"})
user_5 = insert(:user, %{first_name: "Grace"})

group_1 = insert(:group, %{name: "Wild Cats", owner: main_user})
group_2 = insert(:group, %{name: "Team ABC", owner: user_1})
group_3 = insert(:group, %{name: "AwesomePack", owner: user_1})


insert(:user_group, %{user: main_user, group: group_1, state: "accepted"})
insert(:user_group, %{user: main_user, group: group_2, state: "suggested"})
insert(:user_group, %{user: main_user, group: group_3, state: "accepted"})

insert(:user_group, %{user: user_1, group: group_1, state: "applied"})
insert(:user_group, %{user: user_2, group: group_1, state: "applied"})
insert(:user_group, %{user: user_3, group: group_1, state: "applied"})
insert(:user_group, %{user: user_4, group: group_1, state: "accepted"})
insert(:user_group, %{user: user_5, group: group_1, state: "accepted"})

insert(:user_group, %{user: user_1, group: group_2, state: "accepted"})
insert(:user_group, %{user: user_2, group: group_2, state: "accepted"})
insert(:user_group, %{user: user_3, group: group_2, state: "applied"})
insert(:user_group, %{user: user_4, group: group_2, state: "applied"})
insert(:user_group, %{user: user_5, group: group_2, state: "applied"})

insert(:user_group, %{user: user_1, group: group_3, state: "accepted"})

post_1 = insert(:post, %{group: group_1, author: user_1})
post_2 = insert(:post, %{group: group_1, author: user_1})
post_3 = insert(:post, %{group: group_1, author: user_2})
insert_list(200, :post, %{group: group_1, author: user_2})

comment_1 = insert(:comment, %{post: post_1, author: user_2, parent_ids: []})
    comment_1_1 = insert(:comment, %{post: post_1, author: user_3, parent_ids: [comment_1.id]})
    comment_1_2 = insert(:comment, %{post: post_1, author: user_4, parent_ids: [comment_1.id]})
        comment_1_1_1 = insert(:comment, %{post: post_1, author: user_3, parent_ids: [comment_1.id, comment_1_1.id]})
        comment_1_1_2 = insert(:comment, %{post: post_1, author: user_5, parent_ids: [comment_1.id, comment_1_1.id]})
            comment_1_1_2_1 = insert(:comment, %{post: post_1, author: user_5, parent_ids: [comment_1.id, comment_1_1.id, comment_1_1_2.id]})
comment_2 = insert(:comment, %{post: post_1, author: user_2, parent_ids: []})
    comment_2_1 = insert(:comment, %{post: post_1, author: user_2, parent_ids: [comment_2.id]})
