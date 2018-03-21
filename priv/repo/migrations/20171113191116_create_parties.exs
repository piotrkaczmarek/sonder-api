defmodule SonderApi.Repo.Migrations.CreateSubs do
  use Ecto.Migration

  def change do
    create table(:parties) do
      add :size, :integer

      timestamps()
    end

  end
end
