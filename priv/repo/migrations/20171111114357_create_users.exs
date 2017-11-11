defmodule SonderApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :email, :string
      add :facebook_id, :string
      add :facebook_access_token, :string

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:facebook_id])
  end
end
