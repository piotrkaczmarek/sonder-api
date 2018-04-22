defmodule SonderApi.GroupsTest do
  use SonderApi.DataCase

  alias SonderApi.Groups

  describe "groups" do
    alias SonderApi.Groups.Group

    test "list_groups/0 returns all groups" do
      group = insert(:group) |> Repo.preload(:users)
      assert Groups.list_groups() == [group]
    end

    test "get_group!/1 returns the group with given id" do
      group = insert(:group)
      assert Groups.get_group!(group.id).id == group.id
    end

    test "create_group/1 with valid data creates a group" do
      owner = insert(:user)
      attrs = %{name: "test", owner_id: owner.id}
      assert {:ok, %Group{} = group} = Groups.create_group(attrs)
      assert group.name == "test"
      assert group.owner_id == owner.id
    end

    test "create_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Groups.create_group(%{name: nil})
    end

    test "update_group/2 with valid data updates the group" do
      group = insert(:group)
      assert {:ok, group} = Groups.update_group(group, %{name: "new name"})
      assert %Group{} = group
      assert group.name == "new name"
    end

    test "update_group/2 with invalid data returns error changeset" do
      group = insert(:group)
      assert {:error, %Ecto.Changeset{}} = Groups.update_group(group, %{name: nil})
      assert group.name == Groups.get_group!(group.id).name
    end

    test "delete_group/1 deletes the group" do
      group = insert(:group)
      assert {:ok, %Group{}} = Groups.delete_group(group)
      assert_raise Ecto.NoResultsError, fn -> Groups.get_group!(group.id) end
    end

    test "change_group/1 returns a group changeset" do
      group = insert(:group)
      assert %Ecto.Changeset{} = Groups.change_group(group)
    end
  end

  describe "user_groups" do
    alias SonderApi.Groups.UserGroup

    @valid_attrs %{user_id: 1, group_id: 1}
    @update_attrs %{}
    @invalid_attrs %{user_id: nil}

    test "list_user_groups/0 returns all user_groups" do
      user = insert(:user)
      group = insert(:group)
      user_group = insert(:user_group, %{user: user, group: group, state: "accepted"})

      returned_ids = Enum.map(Groups.list_user_groups(), fn(x) -> x.id end)
      assert returned_ids == [user_group.id]
    end

    test "list_members/1 returns only accepted users" do
      user_1 = insert(:user)
      user_2 = insert(:user, %{email: "email2@example.com", facebook_id: "345"})
      user_3 = insert(:user, %{email: "email3@example.com", facebook_id: "123"})
      group = insert(:group)
      insert(:user_group, %{user: user_1, group: group, state: "accepted"})
      insert(:user_group, %{user: user_2, group: group, state: "rejected"})

      assert Groups.list_members(group.id) == [user_1]
    end

    test "get_user_group!/1 returns the user_group with given id" do
      user = insert(:user)
      group = insert(:group)
      user_group = insert(:user_group, %{user: user, group: group, state: "accepted"})

      assert Groups.get_user_group!(user_group.id).id == user_group.id
    end

    test "create_user_group/1 with valid data creates a user_group" do
      user = insert(:user)
      group = insert(:group)
      assert {:ok, %UserGroup{} = user_group} = Groups.create_user_group(%{user_id: user.id, group_id: group.id, state: "accepted"})
    end

    test "create_user_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Groups.create_user_group(@invalid_attrs)
    end

    test "update_user_group/2 with valid data updates the user_group" do
      user = insert(:user)
      group = insert(:group)
      user_group = insert(:user_group, %{user: user, group: group, state: "accepted"})

      assert {:ok, user_group} = Groups.update_user_group(user_group, @update_attrs)
      assert %UserGroup{} = user_group
    end

    test "update_user_group/2 with invalid data returns error changeset" do
      user = insert(:user)
      group = insert(:group)
      invalid_attrs = %{user_id: nil, state: "rejected"}
      user_group = insert(:user_group, %{user: user, group: group, state: "accepted"})

      assert {:error, %Ecto.Changeset{}} = Groups.update_user_group(user_group, invalid_attrs)
      assert "accepted" == Groups.get_user_group!(user_group.id).state
    end

    test "delete_user_group/1 deletes the user_group" do
      user = insert(:user)
      group = insert(:group)
      user_group = insert(:user_group, %{user: user, group: group, state: "accepted"})

      assert {:ok, %UserGroup{}} = Groups.delete_user_group(user_group)
      assert_raise Ecto.NoResultsError, fn -> Groups.get_user_group!(user_group.id) end
    end

    test "change_user_group/1 returns a user_group changeset" do
      user = insert(:user)
      group = insert(:group)
      user_group = insert(:user_group, %{user: user, group: group, state: "accepted"})

      assert %Ecto.Changeset{} = Groups.change_user_group(user_group)
    end
  end
end
