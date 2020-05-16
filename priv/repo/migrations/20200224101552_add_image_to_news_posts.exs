defmodule Plangora.Repo.Migrations.AddImageToNewsPosts do
  use Ecto.Migration

  def change do
    alter table(:news_posts) do
      add :image, :text
      add :zh_body, :text
      add :zh_title, :string
    end
  end
end
