defmodule SonderApi.Repo.Migrations.CreateVotes do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :points, :integer
      add :target_id, :integer
      add :target_class, :string
      add :voter_id, :integer

      timestamps()
    end

  end
end
