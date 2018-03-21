defmodule SonderApi.Subs do
  @moduledoc """
  The Subs context.
  """

  import Ecto.Query, warn: false
  alias SonderApi.Repo

  alias SonderApi.Subs.Sub
  alias SonderApi.Accounts.User
  alias SonderApi.Subs.UserSub

  @doc """
  Returns the list of subs.

  ## Examples

      iex> list_subs()
      [%Sub{}, ...]

  """
  def list_subs do
    Repo.all(Sub)
    |> Repo.preload(:users)
  end

  @doc """
  Returns the list of subs that are suggested to given user.

  ## Examples

      iex> list_suggested_subs(5)
      [%Sub{}, ...]

  """
  def list_suggested_subs(user_id) do
    query = from sub in Sub,
              join: user_sub in UserSub, where: user_sub.sub_id == sub.id,
              where: user_sub.user_id == ^user_id and user_sub.state == "suggested"
    Repo.all(query)
    |> Repo.preload(:users)
  end

  @doc """
  Returns the list of subs that accepted given user.

  ## Examples

      iex> list_accepted_subs(5)
      [%Sub{}, ...]

  """
  def list_accepted_subs(user_id) do
    query = from sub in Sub,
              join: user_sub in UserSub, where: user_sub.sub_id == sub.id,
              where: user_sub.user_id == ^user_id and user_sub.state == "accepted"
    Repo.all(query)
    |> Repo.preload(:users)
  end

 @doc """
  Returns the list of people who applied to given sub.

  ## Examples

      iex> list_applicants(5)
      [%User{}, ...]

  """
  def list_applicants(sub_id) do
    query = from user in User,
              join: user_sub in UserSub, where: user_sub.user_id == user.id,
              where: user_sub.sub_id == ^sub_id and user_sub.state == "applied"
    Repo.all(query)
  end

  @doc """
  Gets a single sub.

  Raises `Ecto.NoResultsError` if the Sub does not exist.

  ## Examples

      iex> get_sub!(123)
      %Sub{}

      iex> get_sub!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sub!(id), do: Repo.get!(Sub, id)

  def get_sub(%{owner_id: owner_id}) do
    Repo.one(from sub in Sub, where: sub.owner_id == ^owner_id)
  end

  @doc """
  Creates a sub.

  ## Examples

      iex> create_sub(%{field: value})
      {:ok, %Sub{}}

      iex> create_sub(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sub(attrs \\ %{}) do
    %Sub{}
    |> Sub.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sub.

  ## Examples

      iex> update_sub(sub, %{field: new_value})
      {:ok, %Sub{}}

      iex> update_sub(sub, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sub(%Sub{} = sub, attrs) do
    sub
    |> Sub.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Sub.

  ## Examples

      iex> delete_sub(sub)
      {:ok, %Sub{}}

      iex> delete_sub(sub)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sub(%Sub{} = sub) do
    Repo.delete(sub)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sub changes.

  ## Examples

      iex> change_sub(sub)
      %Ecto.Changeset{source: %Sub{}}

  """
  def change_sub(%Sub{} = sub) do
    Sub.changeset(sub, %{})
  end

  alias SonderApi.Subs.UserSub
  alias SonderApi.Accounts.User

  def list_members(sub_id) do
    query = from u in User,
              join: up in UserSub,
              where: up.user_id == u.id
                       and up.sub_id == ^sub_id
                       and up.state == "accepted",
              order_by: [asc: up.updated_at]
    Repo.all(query)
  end

  @doc """
  Returns the list of user_subs.

  ## Examples

      iex> list_user_subs()
      [%UserSub{}, ...]

  """
  def list_user_subs do
    Repo.all(UserSub)
  end

  @doc """
  Gets a single user_sub.

  Raises `Ecto.NoResultsError` if the User sub does not exist.

  ## Examples

      iex> get_user_sub!(123)
      %UserSub{}

      iex> get_user_sub!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_sub!(id), do: Repo.get!(UserSub, id)


  @doc """
  Gets a single user_sub.

  Returns `nil` if the User sub does not exist.

  ## Examples

      iex> get_user_sub!(sub_id: 1, user_id: 2)
      %UserSub{}

      iex> get_user_sub!(456)
      nil

  """
  def get_user_sub(%{sub_id: sub_id, user_id: user_id}) do
    Repo.one(from up in UserSub, where: up.user_id == ^user_id and up.sub_id == ^sub_id)
  end

  @doc """
  Creates a user_sub.

  ## Examples

      iex> create_user_sub(%{field: value})
      {:ok, %UserSub{}}

      iex> create_user_sub(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_sub(attrs \\ %{}) do
    %UserSub{}
    |> UserSub.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_sub.

  ## Examples

      iex> update_user_sub(user_sub, %{field: new_value})
      {:ok, %UserSub{}}

      iex> update_user_sub(user_sub, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_sub(%UserSub{} = user_sub, attrs) do
    user_sub
    |> UserSub.changeset(attrs)
    |> Repo.update()
  end


  @doc """
  Creates or Updates a user_sub.
  """
  def upsert_user_sub(attrs = %{user_id: user_id, sub_id: sub_id, state: state}) do
    case get_user_sub(%{user_id: user_id, sub_id: sub_id}) do
      %UserSub{} = user_sub -> update_user_sub(user_sub, attrs)
      nil -> create_user_sub(attrs)
    end
  end

  @doc """
  Deletes a UserSub.

  ## Examples

      iex> delete_user_sub(user_sub)
      {:ok, %UserSub{}}

      iex> delete_user_sub(user_sub)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_sub(%UserSub{} = user_sub) do
    Repo.delete(user_sub)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_sub changes.

  ## Examples

      iex> change_user_sub(user_sub)
      %Ecto.Changeset{source: %UserSub{}}

  """
  def change_user_sub(%UserSub{} = user_sub) do
    UserSub.changeset(user_sub, %{})
  end
end
