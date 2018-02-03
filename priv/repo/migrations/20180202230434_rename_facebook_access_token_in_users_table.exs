defmodule SonderApi.Repo.Migrations.RenameFacebookAccessTokenInUsersTable do
  use Ecto.Migration

  def change do
    rename table(:users), :facebook_access_token, to: :auth_token
  end
end
