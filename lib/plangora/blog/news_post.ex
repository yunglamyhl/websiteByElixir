defmodule Plangora.Blog.NewsPost do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias Plangora.Accounts.Admin

  @slug_regex ~r/^[a-zA-Z0-9-]+$/

  schema "news_posts" do
    field :title, :string
    field :zh_title, :string
    field :body, :string
    field :zh_body, :string
    field :slug, :string
    field :image, :string

    belongs_to(:admin, Admin)

    timestamps()
  end

  @allowed_attrs [
    :title,
    :body,
    :slug,
    :image,
    :zh_body,
    :zh_title
  ]

  @required_attrs [
    :title,
    :body,
    :slug,
    :image
  ]

  def changeset(news_post, attrs) do
    news_post
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs)
    |> validate_length(:title, max: 255)
    |> validate_length(:zh_title, max: 255)
    |> generate_slug()
    |> validate_format(:slug, @slug_regex)
    |> unique_constraint(:slug)
  end

  def search(query, search_term) do
    wildcard_search = "%#{search_term}%"

    from news_post in query,
      where: ilike(news_post.title, ^wildcard_search),
      or_where: ilike(news_post.body, ^wildcard_search)
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
