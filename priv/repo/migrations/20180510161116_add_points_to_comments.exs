defmodule SonderApi.Repo.Migrations.AddPointsToComments do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :points, :integer, default: 0
    end

    create index(:comments, [:points])
  end
end
