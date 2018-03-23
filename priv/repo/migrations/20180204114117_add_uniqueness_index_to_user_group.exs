defmodule SonderApi.Repo.Migrations.AddUniquenessIndexToUserGroup do
  use Ecto.Migration

  def change do
    create unique_index(:user_groups, [:user_id, :group_id], name: :index_user_groups_uniqueness)
  end
end
