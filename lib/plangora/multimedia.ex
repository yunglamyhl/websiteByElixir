defmodule Plangora.Multimedia do
  @moduledoc """
  The Multimedia context.
  """

  import Ecto.Query, warn: false
  alias Plangora.Repo

  alias Plangora.Multimedia.VideoPost
  alias Plangora.Multimedia.VideoCategory

  @doc """
  Returns the list of video_posts.

  ## Examples

      iex> list_video_posts()
      [%VideoPost{}, ...]

  """

  def list_video_posts(params \\ %{}) do
    search_term = get_in(params, ["query"])

    VideoPost
    |> VideoPost.search(search_term)
    |> Repo.all()
  end

  def list_recent_video_posts() do
    Repo.all(from v in VideoPost, order_by: [desc: v.inserted_at], limit: 3)
  end

  def list_video_category_options, do: Repo.all(from(c in VideoCategory, select: {c.title, c.id}))

  def list_video_categories() do
    Repo.all(VideoCategory)
  end

  @doc """
  Gets a single video_post.

  Raises `Ecto.NoResultsError` if the Video post does not exist.

  ## Examples

      iex> get_video_post!(123)
      %VideoPost{}

      iex> get_video_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_video_post!(id), do: Repo.get!(VideoPost, id) |> Repo.preload([:category])

  @doc """
  Gets a single video_post by slug.
  """
  def get_video_post_by_slug(slug), do: from(p in VideoPost, where: p.slug == ^slug) |> Repo.one()

  def get_video_category!(id), do: Repo.get!(VideoCategory, id)

  def get_category_with_video_posts(category_slug) do
    from(c in VideoCategory, where: c.slug == ^category_slug, preload: [:video_posts])
    |> Repo.one()
  end

  @doc """
  Creates a video_post.

  ## Examples

      iex> create_video_post(%{field: value})
      {:ok, %VideoPost{}}

      iex> create_video_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_video_post(attrs, admin_id) do
    %VideoPost{}
    |> VideoPost.create_changeset(attrs)
    |> Ecto.Changeset.put_change(:admin_id, admin_id)
    |> Repo.insert()
  end

  def create_video_category(attrs \\ %{}) do
    %VideoCategory{}
    |> VideoCategory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a video_post.

  ## Examples

      iex> update_video_post(video_post, %{field: new_value})
      {:ok, %VideoPost{}}

      iex> update_video_post(video_post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_video_post(%VideoPost{} = video_post, attrs) do
    video_post
    |> VideoPost.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a VideoPost.

  ## Examples

      iex> delete_video_post(video_post)
      {:ok, %VideoPost{}}

      iex> delete_video_post(video_post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_video_post(%VideoPost{} = video_post) do
    Repo.delete(video_post)
    # video_post
    # |> VideoPost.delete_changeset(%{"is_deleted" => true})
    # |> Repo.update()
  end

  def delete_video_category(%VideoCategory{} = video_category) do
    Repo.delete(video_category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking video_post changes.

  ## Examples

      iex> change_video_post(video_post)
      %Ecto.Changeset{source: %VideoPost{}}

  """
  def change_video_post(%VideoPost{} = video_post) do
    VideoPost.changeset(video_post, %{})
  end

  def change_video_category(%VideoCategory{} = video_category) do
    VideoCategory.changeset(video_category, %{})
  end
end
