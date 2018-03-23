defmodule SonderApi.Repo.Migrations.AddNameToGroups do
  use Ecto.Migration

  def change do
    alter table(:groups) do
      add :name, :string, size: 50
    end

    create index(:groups, [:name])
  end
end
