defmodule Plangora.Repo.Migrations.UpdateVideoPosts do
  use Ecto.Migration

  def change do
    alter table(:video_posts) do
      add :zh_title, :string
      add :zh_description, :text
    end
  end
end
