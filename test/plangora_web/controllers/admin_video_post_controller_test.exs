defmodule PlangoraWeb.AdminVideoPostControllerTest do
  use PlangoraWeb.ConnCase, async: true

  alias Plangora.Multimedia

  @create_attrs %{
    description: "some description",
    slug: "some-slug",
    title: "some title",
    url: "https://www.youtube.com/watch?v=4uy50HJifd0",
    zh_title: "chinese title",
    zh_description: "chinese description"
  }
  @update_attrs %{
    description: "some updated description",
    slug: "some-updated-slug",
    title: "some updated title",
    url: "https://www.youtube.com/watch?v=Z6eEGk5M4ME",
    zh_title: "chinese title",
    zh_description: "chinese description"
  }
  @invalid_attrs %{description: nil, slug: nil, title: nil, url: nil}

  def fixture(attrs, user_id, category_id) do
    {:ok, video_post} =
      attrs
      |> Enum.into(@create_attrs)
      |> Map.put(:category_id, category_id)
      |> Multimedia.create_video_post(user_id)

    video_post
  end

  defp create_video_post(%{admin: admin, category: category}) do
    video_post = fixture(@create_attrs, admin.id, category.id)
    {:ok, video_post: video_post}
  end

  setup %{conn: conn} do
    {:ok, category} =
      Plangora.Multimedia.create_video_category(%{
        title: "title",
        slug: "slug"
      })

    {:ok, admin} =
      Plangora.Accounts.create_admin(%{
        username: "test",
        password: "12345678",
        password_confirmation: "12345678"
      })

    conn =
      conn
      |> bypass_through(PlangoraWeb.Router, :browser)
      |> get("/")
      |> PlangoraWeb.AdminAuth.login(admin)
      |> send_resp(:ok, "")

    {:ok, conn: conn, admin: admin, category: category}
  end

  describe "index" do
    test "lists all video_posts", %{conn: conn} do
      conn = get(conn, Routes.admin_video_post_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing All Video"
    end
  end

  describe "new video_post" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_video_post_path(conn, :new))
      assert html_response(conn, 200) =~ "Create Video"
    end
  end

  describe "create video_post" do
    test "redirects to show when data is valid", %{conn: conn, category: %{id: category_id}} do
      video_post_params = Map.put(@create_attrs, :category_id, category_id)

      conn =
        post(conn, Routes.admin_video_post_path(conn, :create), video_post: video_post_params)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_video_post_path(conn, :show, id)

      conn = get(conn, Routes.admin_video_post_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Description"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.admin_video_post_path(conn, :create), video_post: @invalid_attrs)
      assert html_response(conn, 200) =~ "Create Video"
    end
  end

  describe "edit video_post" do
    setup [:create_video_post]

    test "renders form for editing chosen video_post", %{conn: conn, video_post: video_post} do
      conn = get(conn, Routes.admin_video_post_path(conn, :edit, video_post))
      assert html_response(conn, 200) =~ "Edit"
    end
  end

  describe "update video_post" do
    setup [:create_video_post]

    test "redirects when data is valid", %{conn: conn, video_post: video_post} do
      conn =
        put(conn, Routes.admin_video_post_path(conn, :update, video_post),
          video_post: @update_attrs
        )

      assert redirected_to(conn) == Routes.admin_video_post_path(conn, :show, video_post)

      conn = get(conn, Routes.admin_video_post_path(conn, :show, video_post))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, video_post: video_post} do
      conn =
        put(conn, Routes.admin_video_post_path(conn, :update, video_post),
          video_post: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit"
    end
  end

  describe "delete video_post" do
    setup [:create_video_post]

    test "deletes chosen video_post", %{conn: conn, video_post: video_post} do
      conn = delete(conn, Routes.admin_video_post_path(conn, :delete, video_post))
      assert redirected_to(conn) == Routes.admin_video_post_path(conn, :index)

      # assert_error_sent 404, fn ->
      #   get(conn, Routes.admin_video_post_path(conn, :show, video_post))
      # end
    end
  end
end
