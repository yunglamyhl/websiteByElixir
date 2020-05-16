defmodule Plangora.Repo.Migrations.CreateLeads do
  use Ecto.Migration

  def change do
    create table(:leads) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :phone, :string
      add :message, :text, null: false

      timestamps()
    end
  end
end
