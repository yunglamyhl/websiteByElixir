defmodule PlangoraWeb.VideoPostControllerTest do
  use PlangoraWeb.ConnCase, async: true

  alias Plangora.Multimedia

  @create_attrs %{
    description: "some description",
    slug: "some-slug",
    title: "some title",
    url: "https://www.youtube.com/watch?v=4uy50HJifd0",
    category_id: 1,
    zh_title: "chinese title",
    zh_description: "chinese description"
  }

  def fixture(:video_post, user_id) do
    {:ok, video_post} = Multimedia.create_video_post(@create_attrs, user_id)
    video_post
  end

  describe "index" do
    test "lists all video_posts", %{conn: conn} do
      conn = get(conn, Routes.video_post_path(conn, :index))
      refute html_response(conn, 200) =~ "Listing Video"
    end
  end

  describe "show" do
    setup [:create_video_post]

    test "shows a particular video", %{conn: conn, video_post: video_post} do
      conn = get(conn, Routes.video_post_path(conn, :show, video_post.slug))
      refute html_response(conn, 200) =~ "Descriptions"
    end
  end

  defp create_video_post(_) do
    {:ok, admin} =
      Plangora.Accounts.create_admin(%{
        username: "test",
        password: "12345678",
        password_confirmation: "12345678"
      })

    video_post = fixture(:video_post, admin.id)
    {:ok, video_post: video_post}
  end
end
