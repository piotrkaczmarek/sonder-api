defmodule SonderApi.Repo.Migrations.AddStateToUsersParties do
  use Ecto.Migration

  def change do
    alter table(:user_parties) do
      add :state, :string
    end
  end
end
