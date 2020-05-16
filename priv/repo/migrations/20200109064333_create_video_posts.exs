defmodule Plangora.Repo.Migrations.CreateVideoPosts do
  use Ecto.Migration

  def change do
    create table(:video_posts) do
      add :description, :text
      add :title, :string, null: false
      add :url, :string, null: false
      add :slug, :string, null: false
      add :admin_id, references(:admins, on_delete: :nothing)
      add :is_deleted, :boolean, default: false, null: false

      timestamps()
    end

    create index("video_posts", [:admin_id])
    create unique_index("video_posts", [:slug])
  end
end
