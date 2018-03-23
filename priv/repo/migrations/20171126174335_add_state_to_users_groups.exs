defmodule SonderApi.Repo.Migrations.AddStateToUsersGroups do
  use Ecto.Migration

  def change do
    alter table(:user_groups) do
      add :state, :string
    end
  end
end
