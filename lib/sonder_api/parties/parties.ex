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
  Returns the list of parties.

  ## Examples

      iex> list_parties()
      [%Sub{}, ...]

  """
  def list_parties do
    Repo.all(Sub)
    |> Repo.preload(:users)
  end

  @doc """
  Returns the list of parties that are suggested to given user.

  ## Examples

      iex> list_suggested_parties(5)
      [%Sub{}, ...]

  """
  def list_suggested_parties(user_id) do
    query = from party in Sub,
              join: user_party in UserSub, where: user_party.party_id == party.id,
              where: user_party.user_id == ^user_id and user_party.state == "suggested"
    Repo.all(query)
    |> Repo.preload(:users)
  end

  @doc """
  Returns the list of parties that accepted given user.

  ## Examples

      iex> list_accepted_parties(5)
      [%Sub{}, ...]

  """
  def list_accepted_parties(user_id) do
    query = from party in Sub,
              join: user_party in UserSub, where: user_party.party_id == party.id,
              where: user_party.user_id == ^user_id and user_party.state == "accepted"
    Repo.all(query)
    |> Repo.preload(:users)
  end

 @doc """
  Returns the list of people who applied to given party.

  ## Examples

      iex> list_applicants(5)
      [%User{}, ...]

  """
  def list_applicants(party_id) do
    query = from user in User,
              join: user_party in UserSub, where: user_party.user_id == user.id,
              where: user_party.party_id == ^party_id and user_party.state == "applied"
    Repo.all(query)
  end

  @doc """
  Gets a single party.

  Raises `Ecto.NoResultsError` if the Sub does not exist.

  ## Examples

      iex> get_party!(123)
      %Sub{}

      iex> get_party!(456)
      ** (Ecto.NoResultsError)

  """
  def get_party!(id), do: Repo.get!(Sub, id)

  def get_party(%{owner_id: owner_id}) do
    Repo.one(from party in Sub, where: party.owner_id == ^owner_id)
  end

  @doc """
  Creates a party.

  ## Examples

      iex> create_party(%{field: value})
      {:ok, %Sub{}}

      iex> create_party(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_party(attrs \\ %{}) do
    %Sub{}
    |> Sub.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a party.

  ## Examples

      iex> update_party(party, %{field: new_value})
      {:ok, %Sub{}}

      iex> update_party(party, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_party(%Sub{} = party, attrs) do
    party
    |> Sub.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Sub.

  ## Examples

      iex> delete_party(party)
      {:ok, %Sub{}}

      iex> delete_party(party)
      {:error, %Ecto.Changeset{}}

  """
  def delete_party(%Sub{} = party) do
    Repo.delete(party)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking party changes.

  ## Examples

      iex> change_party(party)
      %Ecto.Changeset{source: %Sub{}}

  """
  def change_party(%Sub{} = party) do
    Sub.changeset(party, %{})
  end

  alias SonderApi.Subs.UserSub
  alias SonderApi.Accounts.User

  def list_members(party_id) do
    query = from u in User,
              join: up in UserSub,
              where: up.user_id == u.id
                       and up.party_id == ^party_id
                       and up.state == "accepted",
              order_by: [asc: up.updated_at]
    Repo.all(query)
  end

  @doc """
  Returns the list of user_parties.

  ## Examples

      iex> list_user_parties()
      [%UserSub{}, ...]

  """
  def list_user_parties do
    Repo.all(UserSub)
  end

  @doc """
  Gets a single user_party.

  Raises `Ecto.NoResultsError` if the User party does not exist.

  ## Examples

      iex> get_user_party!(123)
      %UserSub{}

      iex> get_user_party!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_party!(id), do: Repo.get!(UserSub, id)


  @doc """
  Gets a single user_party.

  Returns `nil` if the User party does not exist.

  ## Examples

      iex> get_user_party!(party_id: 1, user_id: 2)
      %UserSub{}

      iex> get_user_party!(456)
      nil

  """
  def get_user_party(%{party_id: party_id, user_id: user_id}) do
    Repo.one(from up in UserSub, where: up.user_id == ^user_id and up.party_id == ^party_id)
  end

  @doc """
  Creates a user_party.

  ## Examples

      iex> create_user_party(%{field: value})
      {:ok, %UserSub{}}

      iex> create_user_party(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_party(attrs \\ %{}) do
    %UserSub{}
    |> UserSub.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_party.

  ## Examples

      iex> update_user_party(user_party, %{field: new_value})
      {:ok, %UserSub{}}

      iex> update_user_party(user_party, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_party(%UserSub{} = user_party, attrs) do
    user_party
    |> UserSub.changeset(attrs)
    |> Repo.update()
  end


  @doc """
  Creates or Updates a user_party.
  """
  def upsert_user_party(attrs = %{user_id: user_id, party_id: party_id, state: state}) do
    case get_user_party(%{user_id: user_id, party_id: party_id}) do
      %UserSub{} = user_party -> update_user_party(user_party, attrs)
      nil -> create_user_party(attrs)
    end
  end

  @doc """
  Deletes a UserSub.

  ## Examples

      iex> delete_user_party(user_party)
      {:ok, %UserSub{}}

      iex> delete_user_party(user_party)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_party(%UserSub{} = user_party) do
    Repo.delete(user_party)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_party changes.

  ## Examples

      iex> change_user_party(user_party)
      %Ecto.Changeset{source: %UserSub{}}

  """
  def change_user_party(%UserSub{} = user_party) do
    UserSub.changeset(user_party, %{})
  end
end
