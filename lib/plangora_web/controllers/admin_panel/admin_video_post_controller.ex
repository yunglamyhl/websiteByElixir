defmodule PlangoraWeb.AdminVideoPostController do
  use PlangoraWeb, :controller

  alias Plangora.Multimedia
  alias Plangora.Multimedia.VideoPost

  plug :load_category_options when action in [:new, :create, :edit, :update]

  defp load_category_options(conn, _) do
    assign(conn, :video_category_options, Multimedia.list_video_category_options())
  end

  def index(conn, params) do
    video_posts = Multimedia.list_video_posts(params)
    render(conn, "index.html", video_posts: video_posts)
  end

  def new(conn, _params) do
    changeset = Multimedia.change_video_post(%VideoPost{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(%{assigns: %{current_admin: %{id: admin_id}}} = conn, %{
        "video_post" => video_post_params
      }) do
    case Multimedia.create_video_post(video_post_params, admin_id) do
      {:ok, video_post} ->
        conn
        |> put_flash(:info, "Video post created successfully.")
        |> redirect(to: Routes.admin_video_post_path(conn, :show, video_post))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(
          :error,
          "There was an error while creating the video, please fix and try again"
        )
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    video_post = Multimedia.get_video_post!(id)
    render(conn, "show.html", video_post: video_post)
  end

  def edit(conn, %{"id" => id}) do
    video_post = Multimedia.get_video_post!(id)
    changeset = Multimedia.change_video_post(video_post)

    render(conn, "edit.html",
      video_post: video_post,
      changeset: changeset
    )
  end

  def update(conn, %{"id" => id, "video_post" => video_post_params}) do
    video_post = Multimedia.get_video_post!(id)

    case Multimedia.update_video_post(video_post, video_post_params) do
      {:ok, video_post} ->
        conn
        |> put_flash(:info, "Video post updated successfully.")
        |> redirect(to: Routes.admin_video_post_path(conn, :show, video_post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          video_post: video_post,
          changeset: changeset
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    video_post = Multimedia.get_video_post!(id)
    {:ok, _video_post} = Multimedia.delete_video_post(video_post)

    conn
    |> put_flash(:info, "Video post deleted successfully.")
    |> redirect(to: Routes.admin_video_post_path(conn, :index))
  end
end
