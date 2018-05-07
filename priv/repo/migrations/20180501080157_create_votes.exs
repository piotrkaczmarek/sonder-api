defmodule SonderApi.Repo.Migrations.CreateVotes do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :points, :integer
      add :post_id, :integer
      add :comment_id, :integer
      add :voter_id, :integer

      timestamps()
    end

  end
end
