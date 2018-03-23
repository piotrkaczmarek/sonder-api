defmodule SonderApi.GroupsTest do
  use SonderApi.DataCase

  alias SonderApi.Groups

  describe "groups" do
    alias SonderApi.Groups.Group

    @valid_attrs %{size: 42}
    @update_attrs %{size: 43}
    @invalid_attrs %{size: nil}

    test "list_groups/0 returns all groups" do
      group = create_group() |> Repo.preload(:users)
      assert Groups.list_groups() == [group]
    end

    test "get_group!/1 returns the group with given id" do
      group = create_group()
      assert Groups.get_group!(group.id) == group
    end

    test "create_group/1 with valid data creates a group" do
      assert {:ok, %Group{} = group} = Groups.create_group(@valid_attrs)
      assert group.size == 42
    end

    test "create_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Groups.create_group(@invalid_attrs)
    end

    test "update_group/2 with valid data updates the group" do
      group = create_group()
      assert {:ok, group} = Groups.update_group(group, @update_attrs)
      assert %Group{} = group
      assert group.size == 43
    end

    test "update_group/2 with invalid data returns error changeset" do
      group = create_group()
      assert {:error, %Ecto.Changeset{}} = Groups.update_group(group, @invalid_attrs)
      assert group == Groups.get_group!(group.id)
    end

    test "delete_group/1 deletes the group" do
      group = create_group()
      assert {:ok, %Group{}} = Groups.delete_group(group)
      assert_raise Ecto.NoResultsError, fn -> Groups.get_group!(group.id) end
    end

    test "change_group/1 returns a group changeset" do
      group = create_group()
      assert %Ecto.Changeset{} = Groups.change_group(group)
    end
  end

  describe "user_groups" do
    alias SonderApi.Groups.UserGroup

    @valid_attrs %{user_id: 1, group_id: 1}
    @update_attrs %{}
    @invalid_attrs %{user_id: nil}

    test "list_user_groups/0 returns all user_groups" do
      user = create_user()
      group = create_group()
      user_group = create_user_group(%{user_id: user.id, group_id: group.id, state: "accepted"})
      assert Groups.list_user_groups() == [user_group]
    end

    test "list_members/1 returns only accepted users" do
      user_1 = create_user()
      user_2 = create_user(%{email: "email2@example.com", facebook_id: "345"})
      user_3 = create_user(%{email: "email3@example.com", facebook_id: "123"})
      group = create_group()
      create_user_group(%{user_id: user_1.id, group_id: group.id, state: "accepted"})
      create_user_group(%{user_id: user_2.id, group_id: group.id, state: "rejected"})

      assert Groups.list_members(group.id) == [user_1]
    end

    test "get_user_group!/1 returns the user_group with given id" do
      user = create_user()
      group = create_group()
      user_group = create_user_group(%{user_id: user.id, group_id: group.id, state: "accepted"})
      assert Groups.get_user_group!(user_group.id) == user_group
    end

    test "create_user_group/1 with valid data creates a user_group" do
      user = create_user()
      group = create_group()
      assert {:ok, %UserGroup{} = user_group} = Groups.create_user_group(%{user_id: user.id, group_id: group.id, state: "accepted"})
    end

    test "create_user_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Groups.create_user_group(@invalid_attrs)
    end

    test "update_user_group/2 with valid data updates the user_group" do
      user = create_user()
      group = create_group()
      user_group = create_user_group(%{user_id: user.id, group_id: group.id, state: "accepted"})
      assert {:ok, user_group} = Groups.update_user_group(user_group, @update_attrs)
      assert %UserGroup{} = user_group
    end

    test "update_user_group/2 with invalid data returns error changeset" do
      user = create_user()
      group = create_group()
      user_group = create_user_group(%{user_id: user.id, group_id: group.id, state: "accepted"})
      assert {:error, %Ecto.Changeset{}} = Groups.update_user_group(user_group, @invalid_attrs)
      assert user_group == Groups.get_user_group!(user_group.id)
    end

    test "delete_user_group/1 deletes the user_group" do
      user = create_user()
      group = create_group()
      user_group = create_user_group(%{user_id: user.id, group_id: group.id, state: "accepted"})
      assert {:ok, %UserGroup{}} = Groups.delete_user_group(user_group)
      assert_raise Ecto.NoResultsError, fn -> Groups.get_user_group!(user_group.id) end
    end

    test "change_user_group/1 returns a user_group changeset" do
      user = create_user()
      group = create_group()
      user_group = create_user_group(%{user_id: user.id, group_id: group.id, state: "accepted"})
      assert %Ecto.Changeset{} = Groups.change_user_group(user_group)
    end
  end

  defp create_group(attrs \\ %{}) do
    {:ok, group} =
      attrs
      |> Enum.into(%{size: 4})
      |> Groups.create_group()

    group
  end

  defp create_user(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{email: "some email", auth_token: "some auth_token", facebook_id: "some facebook_id", first_name: "some first_name"})
      |> SonderApi.Accounts.create_user()

    user
  end

  defp create_user_group(attrs \\ %{}) do
    {:ok, user_group} =
      attrs
      |> Groups.create_user_group()

    user_group
  end
end
