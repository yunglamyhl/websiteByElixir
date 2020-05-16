defmodule Plangora.Repo.Migrations.CreateVideoCategories do
  use Ecto.Migration

  def change do
    create table(:video_categories) do
      add :title, :string, null: false
      add :slug, :string, null: false
    end

    flush()

    execute "INSERT INTO video_categories (title, slug) VALUES ('Elixir', 'elixir')"
  end
end
