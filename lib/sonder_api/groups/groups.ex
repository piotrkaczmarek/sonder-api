defmodule SonderApi.Groups do
  @moduledoc """
  The Groups context.
  """

  import Ecto.Query, warn: false
  alias SonderApi.Repo

  alias SonderApi.Groups.Group
  alias SonderApi.Accounts.User
  alias SonderApi.Groups.UserGroup

  @doc """
  Returns the list of groups.

  ## Examples

      iex> list_groups()
      [%Group{}, ...]

  """
  def list_groups do
    Repo.all(Group)
    |> Repo.preload(:users)
    |> Repo.preload(:owner)
  end

  @doc """
  Returns the list of groups that are suggested to given user.

  ## Examples

      iex> list_suggested_groups(5)
      [%Group{}, ...]

  """
  def list_suggested_groups(user_id) do
    query = from group in Group,
              join: user_group in UserGroup, where: user_group.group_id == group.id,
              where: user_group.user_id == ^user_id and user_group.state == "suggested"
    Repo.all(query)
    |> Repo.preload(:users)
  end

  @doc """
  Returns the list of groups that accepted given user.

  ## Examples

      iex> list_accepted_groups(5)
      [%Group{}, ...]

  """
  def list_accepted_groups(user_id) do
    query = from group in Group,
              join: user_group in UserGroup, where: user_group.group_id == group.id,
              where: user_group.user_id == ^user_id and user_group.state == "accepted"
    Repo.all(query)
    |> Repo.preload(:users)
  end

 @doc """
  Returns the list of people who applied to given group.

  ## Examples

      iex> list_applicants(5)
      [%User{}, ...]

  """
  def list_applicants(group_id) do
    query = from user in User,
              join: user_group in UserGroup, where: user_group.user_id == user.id,
              where: user_group.group_id == ^group_id and user_group.state == "applied"
    Repo.all(query)
  end

  @doc """
  Gets a single group.

  Raises `Ecto.NoResultsError` if the Group does not exist.

  ## Examples

      iex> get_group!(123)
      %Group{}

      iex> get_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group!(id), do: Repo.get!(Group, id)

  def get_group(%{owner_id: owner_id, group_id: group_id}) do
    Repo.one(from group in Group, where: group.id == ^group_id and group.owner_id == ^owner_id)
  end

  @doc """
  Creates a group.

  ## Examples

      iex> create_group(%{field: value})
      {:ok, %Group{}}

      iex> create_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group(attrs \\ %{}) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group.

  ## Examples

      iex> update_group(group, %{field: new_value})
      {:ok, %Group{}}

      iex> update_group(group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group(%Group{} = group, attrs) do
    group
    |> Group.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Group.

  ## Examples

      iex> delete_group(group)
      {:ok, %Group{}}

      iex> delete_group(group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group(%Group{} = group) do
    Repo.delete(group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group changes.

  ## Examples

      iex> change_group(group)
      %Ecto.Changeset{source: %Group{}}

  """
  def change_group(%Group{} = group) do
    Group.changeset(group, %{})
  end

  alias SonderApi.Groups.UserGroup
  alias SonderApi.Accounts.User

  def list_members(group_id) do
    query = from u in User,
              join: up in UserGroup,
              where: up.user_id == u.id
                       and up.group_id == ^group_id
                       and up.state == "accepted",
              order_by: [asc: up.updated_at]
    Repo.all(query)
  end

  @doc """
  Returns the list of user_groups.

  ## Examples

      iex> list_user_groups()
      [%UserGroup{}, ...]

  """
  def list_user_groups do
    Repo.all(UserGroup)
  end

  @doc """
  Gets a single user_group.

  Raises `Ecto.NoResultsError` if the User group does not exist.

  ## Examples

      iex> get_user_group!(123)
      %UserGroup{}

      iex> get_user_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_group!(id), do: Repo.get!(UserGroup, id)


  @doc """
  Gets a single user_group.

  Returns `nil` if the User group does not exist.

  ## Examples

      iex> get_user_group!(group_id: 1, user_id: 2)
      %UserGroup{}

      iex> get_user_group!(456)
      nil

  """
  def get_user_group(%{group_id: group_id, user_id: user_id}) do
    Repo.one(from up in UserGroup, where: up.user_id == ^user_id and up.group_id == ^group_id)
  end

  @doc """
  Creates a user_group.

  ## Examples

      iex> create_user_group(%{field: value})
      {:ok, %UserGroup{}}

      iex> create_user_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_group(attrs \\ %{}) do
    %UserGroup{}
    |> UserGroup.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_group.

  ## Examples

      iex> update_user_group(user_group, %{field: new_value})
      {:ok, %UserGroup{}}

      iex> update_user_group(user_group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_group(%UserGroup{} = user_group, attrs) do
    user_group
    |> UserGroup.changeset(attrs)
    |> Repo.update()
  end


  @doc """
  Creates or Updates a user_group.
  """
  def upsert_user_group(attrs = %{user_id: user_id, group_id: group_id, state: state}) do
    case get_user_group(%{user_id: user_id, group_id: group_id}) do
      %UserGroup{} = user_group -> update_user_group(user_group, attrs)
      nil -> create_user_group(attrs)
    end
  end

  @doc """
  Deletes a UserGroup.

  ## Examples

      iex> delete_user_group(user_group)
      {:ok, %UserGroup{}}

      iex> delete_user_group(user_group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_group(%UserGroup{} = user_group) do
    Repo.delete(user_group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_group changes.

  ## Examples

      iex> change_user_group(user_group)
      %Ecto.Changeset{source: %UserGroup{}}

  """
  def change_user_group(%UserGroup{} = user_group) do
    UserGroup.changeset(user_group, %{})
  end
end
