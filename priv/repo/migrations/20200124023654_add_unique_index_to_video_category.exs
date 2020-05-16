defmodule Plangora.Repo.Migrations.AddUniqueIndexToVideoCategory do
  use Ecto.Migration

  def change do
    create unique_index(:video_categories, [:title])
  end
end
