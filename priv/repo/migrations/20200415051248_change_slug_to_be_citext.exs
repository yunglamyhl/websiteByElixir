defmodule Plangora.Repo.Migrations.ChangeSlugToBeCitext do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION citext", "DROP EXTENSION citext"

    alter table(:news_posts) do
      modify :slug, :citext, from: :string, null: false
    end

    alter table(:video_posts) do
      modify :slug, :citext, from: :string, null: false
    end
  end
end
