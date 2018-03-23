defmodule SonderApi.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :size, :integer

      timestamps()
    end

  end
end
