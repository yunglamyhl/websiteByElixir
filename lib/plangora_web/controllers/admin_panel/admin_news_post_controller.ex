defmodule PlangoraWeb.AdminNewsPostController do
  use PlangoraWeb, :controller

  alias Plangora.Blog
  alias Plangora.Blog.NewsPost

  def index(conn, params) do
    news_posts = Blog.list_news_posts(params)
    render(conn, "index.html", news_posts: news_posts)
  end

  def new(conn, _params) do
    changeset = Blog.change_news_post(%NewsPost{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(%{assigns: %{current_admin: %{id: admin_id}}} = conn, %{
        "news_post" => news_post_params
      }) do
    case Blog.create_news_post(news_post_params, admin_id) do
      {:ok, news_post} ->
        conn
        |> put_flash(:info, "News post created successfully.")
        |> redirect(to: Routes.admin_news_post_path(conn, :show, news_post))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(
          :error,
          "There was an error while creating the News Post, please fix and try again"
        )
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    news_post = Blog.get_news_post!(id)
    render(conn, "show.html", news_post: news_post)
  end

  def edit(conn, %{"id" => id}) do
    news_post = Blog.get_news_post!(id)
    changeset = Blog.change_news_post(news_post)
    render(conn, "edit.html", news_post: news_post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "news_post" => news_post_params}) do
    news_post = Blog.get_news_post!(id)

    case Blog.update_news_post(news_post, news_post_params) do
      {:ok, news_post} ->
        conn
        |> put_flash(:info, "News post updated successfully.")
        |> redirect(to: Routes.admin_news_post_path(conn, :show, news_post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", news_post: news_post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    news_post = Blog.get_news_post!(id)
    {:ok, _news_post} = Blog.delete_news_post(news_post)

    conn
    |> put_flash(:info, "News post deleted successfully.")
    |> redirect(to: Routes.admin_news_post_path(conn, :index))
  end
end
