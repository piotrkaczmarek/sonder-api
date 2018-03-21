defmodule SonderApi.Repo.Migrations.AddStateToUsersSubs do
  use Ecto.Migration

  def change do
    alter table(:user_subs) do
      add :state, :string
    end
  end
end