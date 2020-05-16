defmodule PlangoraWeb.VideoCategoryController do
  use PlangoraWeb, :controller

  alias Plangora.Multimedia
  alias Plangora.Multimedia.VideoCategory

  def index(conn, _params) do
    video_categories = Multimedia.list_video_categories()
    render(conn, "index.html", video_categories: video_categories)
  end

  def new(conn, _params) do
    changeset = Multimedia.change_video_category(%VideoCategory{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"video_category" => video_category_params}) do
    case Multimedia.create_video_category(video_category_params) do
      {:ok, _video_category} ->
        conn
        |> put_flash(:info, "Video Category created!")
        |> redirect(to: Routes.video_category_path(conn, :new))

      {:error, changeset} ->
        conn
        |> put_flash(
          :error,
          "There was an error while creating the category, please fix and try again"
        )
        |> render("new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    video_category = Multimedia.get_video_category!(id)
    {:ok, _video_category} = Multimedia.delete_video_category(video_category)

    conn
    |> put_flash(:info, "Video category deleted")
    |> redirect(to: Routes.video_category_path(conn, :index))
  end

  def show(conn, %{"category_slug" => category_slug}) do
    video_category = Multimedia.get_category_with_video_posts(category_slug)
    render(conn, "show.html", video_category: video_category)
  end
end
