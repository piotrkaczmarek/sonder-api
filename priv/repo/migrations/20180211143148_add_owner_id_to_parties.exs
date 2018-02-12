defmodule SonderApi.Repo.Migrations.AddOwnerIdToParties do
  use Ecto.Migration

  def change do
    alter table(:parties) do
      add :owner_id, references(:users, on_delete: :nothing)
    end

    create index(:parties, [:owner_id])
  end
end
