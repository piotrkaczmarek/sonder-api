defmodule SonderApi.Parties do
  @moduledoc """
  The Parties context.
  """

  import Ecto.Query, warn: false
  alias SonderApi.Repo

  alias SonderApi.Parties.Party
  alias SonderApi.Parties.UserParty

  @doc """
  Returns the list of parties.

  ## Examples

      iex> list_parties()
      [%Party{}, ...]

  """
  def list_parties do
    Repo.all(Party)
    |> Repo.preload(:users)
  end

  @doc """
  Gets a single party.

  Raises `Ecto.NoResultsError` if the Party does not exist.

  ## Examples

      iex> get_party!(123)
      %Party{}

      iex> get_party!(456)
      ** (Ecto.NoResultsError)

  """
  def get_party!(id), do: Repo.get!(Party, id)

  @doc """
  Creates a party.

  ## Examples

      iex> create_party(%{field: value})
      {:ok, %Party{}}

      iex> create_party(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_party(attrs \\ %{}) do
    %Party{}
    |> Party.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a party.

  ## Examples

      iex> update_party(party, %{field: new_value})
      {:ok, %Party{}}

      iex> update_party(party, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_party(%Party{} = party, attrs) do
    party
    |> Party.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Party.

  ## Examples

      iex> delete_party(party)
      {:ok, %Party{}}

      iex> delete_party(party)
      {:error, %Ecto.Changeset{}}

  """
  def delete_party(%Party{} = party) do
    Repo.delete(party)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking party changes.

  ## Examples

      iex> change_party(party)
      %Ecto.Changeset{source: %Party{}}

  """
  def change_party(%Party{} = party) do
    Party.changeset(party, %{})
  end

  alias SonderApi.Parties.UserParty
  alias SonderApi.Accounts.User

  def list_members(party_id) do
    query = from u in User,
              join: up in UserParty,
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
      [%UserParty{}, ...]

  """
  def list_user_parties do
    Repo.all(UserParty)
  end

  @doc """
  Gets a single user_party.

  Raises `Ecto.NoResultsError` if the User party does not exist.

  ## Examples

      iex> get_user_party!(123)
      %UserParty{}

      iex> get_user_party!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_party!(id), do: Repo.get!(UserParty, id)

  @doc """
  Creates a user_party.

  ## Examples

      iex> create_user_party(%{field: value})
      {:ok, %UserParty{}}

      iex> create_user_party(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_party(attrs \\ %{}) do
    %UserParty{}
    |> UserParty.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_party.

  ## Examples

      iex> update_user_party(user_party, %{field: new_value})
      {:ok, %UserParty{}}

      iex> update_user_party(user_party, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_party(%UserParty{} = user_party, attrs) do
    user_party
    |> UserParty.changeset(attrs)
    |> Repo.update()
  end


  @doc """
  Creates or Updates a user_party.
  """
  def upsert_user_party(attrs = %{user_id: user_id, party_id: party_id, state: state}) do
    case Repo.one(from up in UserParty, where: up.user_id == ^user_id and up.party_id == ^party_id) do
      %UserParty{} = user_party -> update_user_party(user_party, attrs)
      nil -> create_user_party(attrs)
    end
  end

  @doc """
  Deletes a UserParty.

  ## Examples

      iex> delete_user_party(user_party)
      {:ok, %UserParty{}}

      iex> delete_user_party(user_party)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_party(%UserParty{} = user_party) do
    Repo.delete(user_party)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_party changes.

  ## Examples

      iex> change_user_party(user_party)
      %Ecto.Changeset{source: %UserParty{}}

  """
  def change_user_party(%UserParty{} = user_party) do
    UserParty.changeset(user_party, %{})
  end
end
