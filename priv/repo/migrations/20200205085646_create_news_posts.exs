defmodule Plangora.Repo.Migrations.CreateNewsPosts do
  use Ecto.Migration

  def change do
    create table(:news_posts) do
      add :title, :text, null: false
      add :body, :text, null: false
      add :slug, :string, null: false
      add :admin_id, references(:admins, on_delete: :nothing)

      timestamps()
    end

    create index(:news_posts, [:admin_id])
    create unique_index(:news_posts, [:slug])
  end
end
