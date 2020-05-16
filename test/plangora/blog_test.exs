defmodule Plangora.BlogTest do
  use Plangora.DataCase, async: true
  alias Plangora.{Blog, Fixtures}
  alias Plangora.Blog.NewsPost

  setup do
    admin = Fixtures.admin_fixture()

    {:ok, news: Fixtures.news_fixture(%{admin_id: admin.id}), admin: admin}
  end

  describe "news post" do
    test "create_news_post/2 with valid data creates a news post", %{admin: admin} do
      assert {:ok, %NewsPost{} = news_post} =
               Blog.create_news_post(
                 %{
                   body: "some body",
                   slug: "new-slug",
                   title: "some title",
                   image: "some image"
                 },
                 admin.id
               )

      assert news_post.title == "some title"
      assert news_post.body == "some body"
      assert news_post.slug == "new-slug"
    end
  end

  test "create_news_post/2 with invalid data returns error changeset", %{admin: admin} do
    assert {:error, %Ecto.Changeset{}} =
             Blog.create_news_post(%{body: nil, title: nil, slug: nil, image: nil}, admin.id)
  end

  describe "news post created" do
    test "list_news_posts/0 returns all news posts", %{news: news} do
      assert Blog.list_news_posts() == [news]
    end

    test "get_news_post!/1 returns the news post with given id", %{news: news} do
      assert Blog.get_news_post!(news.id) == news
    end

    test "update_news_post/2 with valid data updates the news post", %{news: news} do
      assert {:ok, %NewsPost{} = news_post} =
               Blog.update_news_post(news, %{
                 title: "updated title",
                 body: "updated body",
                 image: "updated image"
               })

      assert news_post.title == "updated title"
      assert news_post.body == "updated body"
    end

    test "update_news_post/2 with invalid data returns error changeset", %{news: news} do
      assert {:error, %Ecto.Changeset{}} =
               Blog.update_news_post(news, %{
                 title: nil,
                 body: nil
               })

      assert news.id == Blog.get_news_post!(news.id).id
      assert news.title == "some title"
    end

    test "delete_news_post/2 deletes the news_post", %{news: news} do
      assert {:ok, %NewsPost{}} = Blog.delete_news_post(news)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_news_post!(news.id) end
    end

    test "change_news_post/1 returns a news post changeset", %{news: news} do
      assert %Ecto.Changeset{} = Blog.change_news_post(news)
    end

    test "get_news_post_by_slug/1 can get news post from different case in slug", %{news: news} do
      assert news =
               news.slug
               |> String.downcase()
               |> Blog.get_news_post_by_slug()

      assert news =
               news.slug
               |> String.upcase()
               |> Blog.get_news_post_by_slug()
    end
  end
end
