defmodule SonderApi.AccountsTest do
  use SonderApi.DataCase

  alias SonderApi.Accounts

  describe "users" do
    alias SonderApi.Accounts.User

    @valid_attrs %{email: "some email", auth_token: "some auth_token", facebook_id: "some facebook_id", first_name: "some first_name"}
    @update_attrs %{email: "some updated email", auth_token: "some updated auth_token", facebook_id: "some updated facebook_id", first_name: "some updated first_name"}
    @invalid_attrs %{email: nil, auth_token: nil, facebook_id: nil, first_name: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.auth_token == "some auth_token"
      assert user.facebook_id == "some facebook_id"
      assert user.first_name == "some first_name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some updated email"
      assert user.auth_token == "some updated auth_token"
      assert user.facebook_id == "some updated facebook_id"
      assert user.first_name == "some updated first_name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "get_or_create_user/1 returns existing user" do
      user = user_fixture()
      assert {:ok, user} == Accounts.get_or_create_user(@valid_attrs)
    end

    test "get_or_create_user/1 creates missing user" do
      assert {:ok, %User{} = user} = Accounts.get_or_create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.auth_token == "some auth_token"
      assert user.facebook_id == "some facebook_id"
      assert user.first_name == "some first_name"
    end
  end
end
