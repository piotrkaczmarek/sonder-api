defmodule SonderApi.Repo.Migrations.AddUniquenessIndexToUserParty do
  use Ecto.Migration

  def change do
    create unique_index(:user_parties, [:user_id, :party_id], name: :index_user_parties_uniqueness)
  end
end
