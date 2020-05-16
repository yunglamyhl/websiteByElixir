defmodule Plangora.Repo.Migrations.AddVideoCategory do
  use Ecto.Migration

  def up do
    alter table(:video_posts) do
      add :category_id, references(:video_categories, on_delete: :nothing)
    end

    flush()

    create index(:video_posts, [:category_id])

    execute "UPDATE video_posts SET category_id = (select id from video_categories limit 1)"

    drop(constraint(:video_posts, "video_posts_category_id_fkey"))

    alter table("video_posts") do
      modify :category_id, references(:video_categories, on_delete: :nothing), null: false
    end
  end

  def down do
    drop(constraint(:video_posts, "video_posts_category_id_fkey"))

    alter table(:video_posts) do
      remove :category_id
    end
  end
end
