defmodule Plangora.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false
  alias Plangora.Repo

  alias Plangora.Blog.NewsPost

  def list_news_posts(params \\ %{}) do
    search_term = get_in(params, ["query"])

    NewsPost
    |> NewsPost.search(search_term)
    |> Repo.all()
  end

  def list_recent_news_posts() do
    Repo.all(from n in NewsPost, order_by: [desc: n.inserted_at], limit: 3)
  end

  def get_news_post!(id), do: Repo.get!(NewsPost, id)

  def get_news_post_by_slug(slug), do: from(p in NewsPost, where: p.slug == ^slug) |> Repo.one()

  def create_news_post(attrs, admin_id) do
    %NewsPost{}
    |> NewsPost.changeset(attrs)
    |> Ecto.Changeset.put_change(:admin_id, admin_id)
    |> Repo.insert()
  end

  def update_news_post(%NewsPost{} = news_post, attrs) do
    news_post
    |> NewsPost.changeset(attrs)
    |> Repo.update()
  end

  def delete_news_post(%NewsPost{} = news_post) do
    Repo.delete(news_post)
  end

  def change_news_post(%NewsPost{} = news_post) do
    NewsPost.changeset(news_post, %{})
  end
end
