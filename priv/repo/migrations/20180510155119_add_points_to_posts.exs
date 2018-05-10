defmodule SonderApi.Repo.Migrations.AddPointsToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :points, :integer, default: 0
    end

    create index(:posts, [:points])
  end
end
