defmodule SonderApi.Repo.Migrations.CreateUserSubs do
  use Ecto.Migration

  def change do
    create table(:user_subs) do
      add :user_id, references(:users, on_delete: :nothing)
      add :sub_id, references(:subs, on_delete: :nothing)

      timestamps()
    end

    create index(:user_subs, [:user_id])
    create index(:user_subs, [:sub_id])
  end
end
