defmodule Plangora.MultimediaTest do
  use Plangora.DataCase, async: true

  alias Plangora.Multimedia
  alias Plangora.Multimedia.VideoPost

  @valid_attrs %{
    description: "some description",
    slug: "some-slug",
    title: "some title",
    url: "https://www.youtube.com/watch?v=4uy50HJifd0",
    is_deleted: false,
    category_id: 1,
    zh_title: "chinese title",
    zh_description: "chinese description"
  }
  @update_attrs %{
    description: "some updated description",
    slug: "some-updated-slug",
    title: "some updated title",
    url: "https://www.youtube.com/watch?v=4uy50HJifd0",
    is_deleted: false,
    zh_title: "chinese title",
    zh_description: "chinese description"
  }
  @invalid_attrs %{description: nil, slug: nil, title: nil, url: nil}

  setup do
    {:ok, category} =
      Plangora.Multimedia.create_video_category(%{
        title: "title",
        slug: "slug"
      })

    {:ok, admin1} =
      Plangora.Accounts.create_admin(%{
        username: "test1",
        password: "12345678",
        password_confirmation: "12345678"
      })

    {:ok, admin2} =
      Plangora.Accounts.create_admin(%{
        username: "test2",
        password: "12345678",
        password_confirmation: "12345678"
      })

    {:ok, admin: [admin1, admin2], category: category}
  end

  def attr_changeset(_) do
    {:ok, [valid_attrs: @valid_attrs]}
  end

  def video_post_fixture(attrs, user_id, category_id) do
    {:ok, video_post} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Map.put(:category_id, category_id)
      |> Multimedia.create_video_post(user_id)

    video_post
  end

  test "list_video_posts/0 returns all video_posts", %{admin: admin, category: %{id: category_id}} do
    video_posts =
      Enum.map(admin, fn x -> video_post_fixture(%{slug: "slug#{x.id}"}, x.id, category_id) end)

    assert Multimedia.list_video_posts() == video_posts
  end

  describe "invalid link" do
    setup [:attr_changeset]

    test "cannot create video with invalid youtube link", %{admin: admin, valid_attrs: attrs} do
      errors = [
        url: {"Invalid YouTube link", [validation: :format]}
      ]

      assert {:ok, @valid_attrs} =
               Multimedia.create_video_post(@valid_attrs, Enum.at(admin, 1).id)

      assert {:error, %{valid?: false, errors: ^errors}} =
               Multimedia.create_video_post(
                 %{attrs | url: "https://youku.com/69240222"},
                 Enum.at(admin, 1).id
               )
    end
  end

  test "create_video_post/1 with valid data creates a video_post", %{admin: admin} do
    assert {:ok, %VideoPost{} = video_post} =
             Multimedia.create_video_post(@valid_attrs, Enum.at(admin, 1).id)

    assert video_post.description == "some description"
    assert video_post.slug == "some-slug"
    assert video_post.title == "some title"
    assert video_post.url == "https://www.youtube.com/watch?v=4uy50HJifd0"
  end

  test "create_video_post/1 with invalid data returns error changeset", %{admin: admin} do
    assert {:error, %Ecto.Changeset{}} =
             Multimedia.create_video_post(@invalid_attrs, Enum.at(admin, 0).id)
  end

  describe "video_post created" do
    setup %{admin: admin, category: %{id: category_id}},
      do: {:ok, video_post: video_post_fixture(@valid_attrs, Enum.at(admin, 0).id, category_id)}

    test "get_video_post!/1 returns the video_post with given id", %{video_post: video_post} do
      assert Multimedia.get_video_post!(video_post.id).id == video_post.id
    end

    test "update_video_post/2 with valid data updates the video_post", %{video_post: video_post} do
      assert {:ok, %VideoPost{} = video_post} =
               Multimedia.update_video_post(video_post, @update_attrs)

      assert video_post.description == "some updated description"
      assert video_post.slug == "some-updated-slug"
      assert video_post.title == "some updated title"
      assert video_post.url == "https://www.youtube.com/watch?v=4uy50HJifd0"
    end

    test "update_video_post/2 with invalid data returns error changeset", %{
      video_post: video_post
    } do
      assert {:error, %Ecto.Changeset{}} =
               Multimedia.update_video_post(video_post, @invalid_attrs)

      assert video_post.id == Multimedia.get_video_post!(video_post.id).id
    end

    test "delete_video_post/2 deletes the video_post", %{video_post: video_post} do
      assert {:ok, %VideoPost{}} = Multimedia.delete_video_post(video_post)
      assert_raise Ecto.NoResultsError, fn -> Multimedia.get_video_post!(video_post.id) end
    end

    test "change_video_post/1 returns a video_post changeset", %{video_post: video_post} do
      assert %Ecto.Changeset{} = Multimedia.change_video_post(video_post)
    end

    test "get_video_post_by_slug/1 can accept mixed case", %{video_post: video_post} do
      assert video_post =
               video_post.slug
               |> String.downcase()
               |> Multimedia.get_video_post_by_slug()

      assert video_post =
               video_post.slug
               |> String.upcase()
               |> Multimedia.get_video_post_by_slug()
    end
  end
end
