defmodule Plangora.Fixtures do
  alias Plangora.{Accounts, Multimedia, Blog}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some@email.com",
        name: "some name",
        password: "testpassword",
        password_confirmation: "testpassword"
      })
      |> Accounts.create_user()

    %{user | password: nil, password_confirmation: nil}
  end

  def admin_fixture(attrs \\ %{}) do
    {:ok, admin} =
      attrs
      |> Enum.into(%{
        username: "some username",
        password: "testpassword",
        password_confirmation: "testpassword"
      })
      |> Accounts.create_admin()

    %{admin | password: nil, password_confirmation: nil}
  end

  def video_category_fixture(attrs \\ %{}) do
    {:ok, video_category} =
      attrs
      |> Enum.into(%{
        title: "some title",
        slug: "some slug"
      })

    video_category
  end

  def video_fixture(attrs \\ %{}) do
    {:ok, video} =
      attrs
      |> Enum.into(%{
        description: "some description",
        slug: "some-slug",
        title: "some title",
        url: "https://www.youtube.com/watch?v=4uy50HJifd0",
        is_deleted: false,
        zh_title: "chinese title",
        zh_description: "chinese description"
      })
      |> Multimedia.create_video_post(Map.get(attrs, :admin_id))

    video
  end

  def news_fixture(attrs \\ %{}) do
    {:ok, news} =
      attrs
      |> Enum.into(%{
        title: "some title",
        body: "some body",
        slug: "some-slug",
        image: "some image"
      })
      |> Blog.create_news_post(Map.get(attrs, :admin_id))

    news
  end
end
