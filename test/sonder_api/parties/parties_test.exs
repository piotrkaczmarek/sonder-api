defmodule SonderApi.SubsTest do
  use SonderApi.DataCase

  alias SonderApi.Subs

  describe "subs" do
    alias SonderApi.Subs.Sub

    @valid_attrs %{size: 42}
    @update_attrs %{size: 43}
    @invalid_attrs %{size: nil}

    test "list_subs/0 returns all subs" do
      sub = create_sub() |> Repo.preload(:users)
      assert Subs.list_subs() == [sub]
    end

    test "get_sub!/1 returns the sub with given id" do
      sub = create_sub()
      assert Subs.get_sub!(sub.id) == sub
    end

    test "create_sub/1 with valid data creates a sub" do
      assert {:ok, %Sub{} = sub} = Subs.create_sub(@valid_attrs)
      assert sub.size == 42
    end

    test "create_sub/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Subs.create_sub(@invalid_attrs)
    end

    test "update_sub/2 with valid data updates the sub" do
      sub = create_sub()
      assert {:ok, sub} = Subs.update_sub(sub, @update_attrs)
      assert %Sub{} = sub
      assert sub.size == 43
    end

    test "update_sub/2 with invalid data returns error changeset" do
      sub = create_sub()
      assert {:error, %Ecto.Changeset{}} = Subs.update_sub(sub, @invalid_attrs)
      assert sub == Subs.get_sub!(sub.id)
    end

    test "delete_sub/1 deletes the sub" do
      sub = create_sub()
      assert {:ok, %Sub{}} = Subs.delete_sub(sub)
      assert_raise Ecto.NoResultsError, fn -> Subs.get_sub!(sub.id) end
    end

    test "change_sub/1 returns a sub changeset" do
      sub = create_sub()
      assert %Ecto.Changeset{} = Subs.change_sub(sub)
    end
  end

  describe "user_subs" do
    alias SonderApi.Subs.UserSub

    @valid_attrs %{user_id: 1, sub_id: 1}
    @update_attrs %{}
    @invalid_attrs %{user_id: nil}

    test "list_user_subs/0 returns all user_subs" do
      user = create_user()
      sub = create_sub()
      user_sub = create_user_sub(%{user_id: user.id, sub_id: sub.id, state: "accepted"})
      assert Subs.list_user_subs() == [user_sub]
    end

    test "list_members/1 returns only accepted users" do
      user_1 = create_user()
      user_2 = create_user(%{email: "email2@example.com", facebook_id: "345"})
      user_3 = create_user(%{email: "email3@example.com", facebook_id: "123"})
      sub = create_sub()
      create_user_sub(%{user_id: user_1.id, sub_id: sub.id, state: "accepted"})
      create_user_sub(%{user_id: user_2.id, sub_id: sub.id, state: "rejected"})

      assert Subs.list_members(sub.id) == [user_1]
    end

    test "get_user_sub!/1 returns the user_sub with given id" do
      user = create_user()
      sub = create_sub()
      user_sub = create_user_sub(%{user_id: user.id, sub_id: sub.id, state: "accepted"})
      assert Subs.get_user_sub!(user_sub.id) == user_sub
    end

    test "create_user_sub/1 with valid data creates a user_sub" do
      user = create_user()
      sub = create_sub()
      assert {:ok, %UserSub{} = user_sub} = Subs.create_user_sub(%{user_id: user.id, sub_id: sub.id, state: "accepted"})
    end

    test "create_user_sub/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Subs.create_user_sub(@invalid_attrs)
    end

    test "update_user_sub/2 with valid data updates the user_sub" do
      user = create_user()
      sub = create_sub()
      user_sub = create_user_sub(%{user_id: user.id, sub_id: sub.id, state: "accepted"})
      assert {:ok, user_sub} = Subs.update_user_sub(user_sub, @update_attrs)
      assert %UserSub{} = user_sub
    end

    test "update_user_sub/2 with invalid data returns error changeset" do
      user = create_user()
      sub = create_sub()
      user_sub = create_user_sub(%{user_id: user.id, sub_id: sub.id, state: "accepted"})
      assert {:error, %Ecto.Changeset{}} = Subs.update_user_sub(user_sub, @invalid_attrs)
      assert user_sub == Subs.get_user_sub!(user_sub.id)
    end

    test "delete_user_sub/1 deletes the user_sub" do
      user = create_user()
      sub = create_sub()
      user_sub = create_user_sub(%{user_id: user.id, sub_id: sub.id, state: "accepted"})
      assert {:ok, %UserSub{}} = Subs.delete_user_sub(user_sub)
      assert_raise Ecto.NoResultsError, fn -> Subs.get_user_sub!(user_sub.id) end
    end

    test "change_user_sub/1 returns a user_sub changeset" do
      user = create_user()
      sub = create_sub()
      user_sub = create_user_sub(%{user_id: user.id, sub_id: sub.id, state: "accepted"})
      assert %Ecto.Changeset{} = Subs.change_user_sub(user_sub)
    end
  end

  defp create_sub(attrs \\ %{}) do
    {:ok, sub} =
      attrs
      |> Enum.into(%{size: 4})
      |> Subs.create_sub()

    sub
  end

  defp create_user(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{email: "some email", auth_token: "some auth_token", facebook_id: "some facebook_id", first_name: "some first_name"})
      |> SonderApi.Accounts.create_user()

    user
  end

  defp create_user_sub(attrs \\ %{}) do
    {:ok, user_sub} =
      attrs
      |> Subs.create_user_sub()

    user_sub
  end
end
