defmodule SonderApi.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :body, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :sub_id, references(:subs, on_delete: :nothing)

      timestamps()
    end
  end
end
