defmodule Plangora.Repo.Migrations.CreateAdmins do
  use Ecto.Migration

  def change do
    create table(:admins) do
      add :username, :string, null: false
      add :password_hash, :string, null: false
      add :is_active, :boolean, default: true, null: false

      timestamps()
    end

    create unique_index(:admins, [:username])
  end
end
