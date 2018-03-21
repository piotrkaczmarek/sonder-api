defmodule SonderApi.SubsTest do
  use SonderApi.DataCase

  alias SonderApi.Subs

  describe "parties" do
    alias SonderApi.Subs.Sub

    @valid_attrs %{size: 42}
    @update_attrs %{size: 43}
    @invalid_attrs %{size: nil}

    test "list_parties/0 returns all parties" do
      party = create_party() |> Repo.preload(:users)
      assert Subs.list_parties() == [party]
    end

    test "get_party!/1 returns the party with given id" do
      party = create_party()
      assert Subs.get_party!(party.id) == party
    end

    test "create_party/1 with valid data creates a party" do
      assert {:ok, %Sub{} = party} = Subs.create_party(@valid_attrs)
      assert party.size == 42
    end

    test "create_party/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Subs.create_party(@invalid_attrs)
    end

    test "update_party/2 with valid data updates the party" do
      party = create_party()
      assert {:ok, party} = Subs.update_party(party, @update_attrs)
      assert %Sub{} = party
      assert party.size == 43
    end

    test "update_party/2 with invalid data returns error changeset" do
      party = create_party()
      assert {:error, %Ecto.Changeset{}} = Subs.update_party(party, @invalid_attrs)
      assert party == Subs.get_party!(party.id)
    end

    test "delete_party/1 deletes the party" do
      party = create_party()
      assert {:ok, %Sub{}} = Subs.delete_party(party)
      assert_raise Ecto.NoResultsError, fn -> Subs.get_party!(party.id) end
    end

    test "change_party/1 returns a party changeset" do
      party = create_party()
      assert %Ecto.Changeset{} = Subs.change_party(party)
    end
  end

  describe "user_parties" do
    alias SonderApi.Subs.UserSub

    @valid_attrs %{user_id: 1, party_id: 1}
    @update_attrs %{}
    @invalid_attrs %{user_id: nil}

    test "list_user_parties/0 returns all user_parties" do
      user = create_user()
      party = create_party()
      user_party = create_user_party(%{user_id: user.id, party_id: party.id, state: "accepted"})
      assert Subs.list_user_parties() == [user_party]
    end

    test "list_members/1 returns only accepted users" do
      user_1 = create_user()
      user_2 = create_user(%{email: "email2@example.com", facebook_id: "345"})
      user_3 = create_user(%{email: "email3@example.com", facebook_id: "123"})
      party = create_party()
      create_user_party(%{user_id: user_1.id, party_id: party.id, state: "accepted"})
      create_user_party(%{user_id: user_2.id, party_id: party.id, state: "rejected"})

      assert Subs.list_members(party.id) == [user_1]
    end

    test "get_user_party!/1 returns the user_party with given id" do
      user = create_user()
      party = create_party()
      user_party = create_user_party(%{user_id: user.id, party_id: party.id, state: "accepted"})
      assert Subs.get_user_party!(user_party.id) == user_party
    end

    test "create_user_party/1 with valid data creates a user_party" do
      user = create_user()
      party = create_party()
      assert {:ok, %UserSub{} = user_party} = Subs.create_user_party(%{user_id: user.id, party_id: party.id, state: "accepted"})
    end

    test "create_user_party/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Subs.create_user_party(@invalid_attrs)
    end

    test "update_user_party/2 with valid data updates the user_party" do
      user = create_user()
      party = create_party()
      user_party = create_user_party(%{user_id: user.id, party_id: party.id, state: "accepted"})
      assert {:ok, user_party} = Subs.update_user_party(user_party, @update_attrs)
      assert %UserSub{} = user_party
    end

    test "update_user_party/2 with invalid data returns error changeset" do
      user = create_user()
      party = create_party()
      user_party = create_user_party(%{user_id: user.id, party_id: party.id, state: "accepted"})
      assert {:error, %Ecto.Changeset{}} = Subs.update_user_party(user_party, @invalid_attrs)
      assert user_party == Subs.get_user_party!(user_party.id)
    end

    test "delete_user_party/1 deletes the user_party" do
      user = create_user()
      party = create_party()
      user_party = create_user_party(%{user_id: user.id, party_id: party.id, state: "accepted"})
      assert {:ok, %UserSub{}} = Subs.delete_user_party(user_party)
      assert_raise Ecto.NoResultsError, fn -> Subs.get_user_party!(user_party.id) end
    end

    test "change_user_party/1 returns a user_party changeset" do
      user = create_user()
      party = create_party()
      user_party = create_user_party(%{user_id: user.id, party_id: party.id, state: "accepted"})
      assert %Ecto.Changeset{} = Subs.change_user_party(user_party)
    end
  end

  defp create_party(attrs \\ %{}) do
    {:ok, party} =
      attrs
      |> Enum.into(%{size: 4})
      |> Subs.create_party()

    party
  end

  defp create_user(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{email: "some email", auth_token: "some auth_token", facebook_id: "some facebook_id", first_name: "some first_name"})
      |> SonderApi.Accounts.create_user()

    user
  end

  defp create_user_party(attrs \\ %{}) do
    {:ok, user_party} =
      attrs
      |> Subs.create_user_party()

    user_party
  end
end
