defmodule SonderApi.Repo.Migrations.AddNameToParties do
  use Ecto.Migration

  def change do
    alter table(:parties) do
      add :name, :string, size: 50
    end

    create index(:parties, [:name])
  end
end
