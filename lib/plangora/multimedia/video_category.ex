defmodule Plangora.Multimedia.VideoCategory do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plangora.Multimedia.VideoPost

  schema "video_categories" do
    field :title, :string
    field :slug, :string

    has_many(:video_posts, VideoPost, foreign_key: :category_id)
  end

  @slug_regex ~r/^[a-zA-Z0-9-]+$/

  @required_attrs [
    :title,
    :slug
  ]

  def changeset(video_category, attrs) do
    video_category
    |> cast(attrs, @required_attrs)
    |> unique_constraint(:title)
    |> generate_slug()
    |> validate_required(@required_attrs)
    |> validate_format(:slug, @slug_regex, message: "Invalid Format")
  end

  def generate_slug(%Ecto.Changeset{} = changeset) do
    slug = get_field(changeset, :slug)
    title = get_field(changeset, :title)

    cond do
      not is_nil(slug) ->
        change(changeset, slug: slug)

      is_nil(slug) and not is_nil(title) ->
        change(changeset, slug: Slug.slugify(title))

      true ->
        changeset
    end
  end
end
