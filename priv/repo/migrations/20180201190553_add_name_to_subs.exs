defmodule SonderApi.Repo.Migrations.AddNameToSubs do
  use Ecto.Migration

  def change do
    alter table(:subs) do
      add :name, :string, size: 50
    end

    create index(:subs, [:name])
  end
end
