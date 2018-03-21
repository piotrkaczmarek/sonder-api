defmodule SonderApi.Repo.Migrations.AddUniquenessIndexToUserSub do
  use Ecto.Migration

  def change do
    create unique_index(:user_subs, [:user_id, :sub_id], name: :index_user_subs_uniqueness)
  end
end
