defmodule SonderApi.Repo.Migrations.CreateSubs do
  use Ecto.Migration

  def change do
    create table(:subs) do
      add :size, :integer

      timestamps()
    end

  end
end
