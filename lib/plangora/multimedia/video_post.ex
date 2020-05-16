defmodule Plangora.Multimedia.VideoPost do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias Plangora.Accounts.Admin
  alias Plangora.Multimedia.VideoCategory

  @video_regex ~r/\Ahttps?:\/\/(?:www\.)?(?:youtu\.be|youtube\.com)\/(?:watch\?v=)*(?<youtube_id>[a-zA-Z0-9_-]{11})?/
  # @youtube_thumbnail_regex ~r/\Ahttps?:\/\/(?:www\.img\.youtube\.com)\/(?:vi)\/*(?<vid>[a-zA-Z0-9_-]{11})\/(?:maxresdefault\.jpg)?/
  @slug_regex ~r/^[a-zA-Z0-9-]+$/

  schema "video_posts" do
    field :description, :string
    field :slug, :string
    field :title, :string
    field :url, :string
    field :is_deleted, :boolean, default: false
    field :zh_title, :string
    field :zh_description, :string

    belongs_to(:admin, Admin)
    belongs_to(:category, VideoCategory)

    timestamps()
  end

  @required_attributes [
    :description,
    :title,
    :url,
    :slug,
    :is_deleted,
    :category_id
  ]

  @cast_attributes [
    :description,
    :title,
    :url,
    :slug,
    :is_deleted,
    :category_id,
    :zh_title,
    :zh_description
  ]

  @doc false
  def changeset(video_post, attrs) do
    video_post
    |> cast(attrs, @cast_attributes)
    |> generate_slug()
    |> validate_required(@required_attributes)
    |> validate_length(:title, max: 255, message: "should be at most %{count} characters")
    |> validate_format(:slug, @slug_regex,
      message: "Slug should be unique and No SPACE or @#$%^&*()+=: should be used."
    )
    |> validate_format(:url, @video_regex, message: "Invalid YouTube link")
    |> unique_constraint(:slug)
  end

  def create_changeset(video_post, attrs) do
    changeset(video_post, attrs)
  end

  def delete_changeset(video_post, attrs) do
    video_post
    |> cast(attrs, [:is_deleted])
  end

  def search(query, search_term) do
    wildcard_search = "%#{search_term}%"

    from video_post in query,
      where: ilike(video_post.title, ^wildcard_search),
      or_where: ilike(video_post.description, ^wildcard_search)
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

  def video_regex, do: @video_regex
end
