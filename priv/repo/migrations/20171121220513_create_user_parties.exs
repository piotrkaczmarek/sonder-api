defmodule SonderApi.Repo.Migrations.CreateUserSubs do
  use Ecto.Migration

  def change do
    create table(:user_parties) do
      add :user_id, references(:users, on_delete: :nothing)
      add :sub_id, references(:parties, on_delete: :nothing)

      timestamps()
    end

    create index(:user_parties, [:user_id])
    create index(:user_parties, [:sub_id])
  end
end
