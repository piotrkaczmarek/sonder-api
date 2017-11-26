defmodule SonderApi.PartiesTest do
  use SonderApi.DataCase

  alias SonderApi.Parties

  describe "parties" do
    alias SonderApi.Parties.Party

    @valid_attrs %{size: 42}
    @update_attrs %{size: 43}
    @invalid_attrs %{size: nil}

    test "list_parties/0 returns all parties" do
      party = create_party() |> Repo.preload(:users)
      assert Parties.list_parties() == [party]
    end

    test "get_party!/1 returns the party with given id" do
      party = create_party()
      assert Parties.get_party!(party.id) == party
    end

    test "create_party/1 with valid data creates a party" do
      assert {:ok, %Party{} = party} = Parties.create_party(@valid_attrs)
      assert party.size == 42
    end

    test "create_party/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Parties.create_party(@invalid_attrs)
    end

    test "update_party/2 with valid data updates the party" do
      party = create_party()
      assert {:ok, party} = Parties.update_party(party, @update_attrs)
      assert %Party{} = party
      assert party.size == 43
    end

    test "update_party/2 with invalid data returns error changeset" do
      party = create_party()
      assert {:error, %Ecto.Changeset{}} = Parties.update_party(party, @invalid_attrs)
      assert party == Parties.get_party!(party.id)
    end

    test "delete_party/1 deletes the party" do
      party = create_party()
      assert {:ok, %Party{}} = Parties.delete_party(party)
      assert_raise Ecto.NoResultsError, fn -> Parties.get_party!(party.id) end
    end

    test "change_party/1 returns a party changeset" do
      party = create_party()
      assert %Ecto.Changeset{} = Parties.change_party(party)
    end
  end

  describe "user_parties" do
    alias SonderApi.Parties.UserParty

    @valid_attrs %{user_id: 1, party_id: 1}
    @update_attrs %{}
    @invalid_attrs %{user_id: nil}

    test "list_user_parties/0 returns all user_parties" do
      user = create_user()
      party = create_party()
      user_party = create_user_party(%{user_id: user.id, party_id: party.id, state: "accepted"})
      assert Parties.list_user_parties() == [user_party]
    end

    test "list_members/1 returns only accepted users" do
      user_1 = create_user()
      user_2 = create_user(%{email: "email2@example.com", facebook_id: "345"})
      user_3 = create_user(%{email: "email3@example.com", facebook_id: "123"})
      party = create_party()
      create_user_party(%{user_id: user_1.id, party_id: party.id, state: "accepted"})
      create_user_party(%{user_id: user_2.id, party_id: party.id, state: "rejected"})

      assert Parties.list_members(party.id) == [user_1]
    end

    test "get_user_party!/1 returns the user_party with given id" do
      user = create_user()
      party = create_party()
      user_party = create_user_party(%{user_id: user.id, party_id: party.id, state: "accepted"})
      assert Parties.get_user_party!(user_party.id) == user_party
    end

    test "create_user_party/1 with valid data creates a user_party" do
      user = create_user()
      party = create_party()
      assert {:ok, %UserParty{} = user_party} = Parties.create_user_party(%{user_id: user.id, party_id: party.id, state: "accepted"})
    end

    test "create_user_party/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Parties.create_user_party(@invalid_attrs)
    end

    test "update_user_party/2 with valid data updates the user_party" do
      user = create_user()
      party = create_party()
      user_party = create_user_party(%{user_id: user.id, party_id: party.id, state: "accepted"})
      assert {:ok, user_party} = Parties.update_user_party(user_party, @update_attrs)
      assert %UserParty{} = user_party
    end

    test "update_user_party/2 with invalid data returns error changeset" do
      user = create_user()
      party = create_party()
      user_party = create_user_party(%{user_id: user.id, party_id: party.id, state: "accepted"})
      assert {:error, %Ecto.Changeset{}} = Parties.update_user_party(user_party, @invalid_attrs)
      assert user_party == Parties.get_user_party!(user_party.id)
    end

    test "delete_user_party/1 deletes the user_party" do
      user = create_user()
      party = create_party()
      user_party = create_user_party(%{user_id: user.id, party_id: party.id, state: "accepted"})
      assert {:ok, %UserParty{}} = Parties.delete_user_party(user_party)
      assert_raise Ecto.NoResultsError, fn -> Parties.get_user_party!(user_party.id) end
    end

    test "change_user_party/1 returns a user_party changeset" do
      user = create_user()
      party = create_party()
      user_party = create_user_party(%{user_id: user.id, party_id: party.id, state: "accepted"})
      assert %Ecto.Changeset{} = Parties.change_user_party(user_party)
    end
  end

  defp create_party(attrs \\ %{}) do
    {:ok, party} =
      attrs
      |> Enum.into(%{size: 4})
      |> Parties.create_party()

    party
  end

  defp create_user(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{email: "some email", facebook_access_token: "some facebook_access_token", facebook_id: "some facebook_id", first_name: "some first_name"})
      |> SonderApi.Accounts.create_user()

    user
  end

  defp create_user_party(attrs \\ %{}) do
    {:ok, user_party} =
      attrs
      |> Parties.create_user_party()

    user_party
  end
end
