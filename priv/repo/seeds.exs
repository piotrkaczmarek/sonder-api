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



user_1 = SonderApi.Repo.insert!(%SonderApi.Accounts.User{first_name: "Bob", facebook_id: "12345", facebook_access_token: "abcd"})
user_2 = SonderApi.Repo.insert!(%SonderApi.Accounts.User{first_name: "Susan", facebook_id: "23456", facebook_access_token: "bcde"})


party_1 = SonderApi.Repo.insert!(%SonderApi.Parties.Party{size: 3, name: "Wild Cats"})
party_2 = SonderApi.Repo.insert!(%SonderApi.Parties.Party{size: 5, name: "Team ABC"})

SonderApi.Repo.insert!(%SonderApi.Parties.UserParty{user_id: user_1.id, party_id: party_1.id, state: "accepted"})
SonderApi.Repo.insert!(%SonderApi.Parties.UserParty{user_id: user_2.id, party_id: party_1.id, state: "accepted"})
SonderApi.Repo.insert!(%SonderApi.Parties.UserParty{user_id: user_1.id, party_id: party_2.id, state: "accepted"})
