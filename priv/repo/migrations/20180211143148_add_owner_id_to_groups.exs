defmodule SonderApi.Repo.Migrations.AddOwnerIdToGroups do
  use Ecto.Migration

  def change do
    alter table(:groups) do
      add :owner_id, references(:users, on_delete: :nothing)
    end

    create index(:groups, [:owner_id])
  end
end
