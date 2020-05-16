defmodule PlangoraWeb.NewsPostController do
  use PlangoraWeb, :controller

  alias Plangora.Blog

  def index(conn, params) do
    news_posts = Blog.list_news_posts(params)
    render(conn, "index.html", news_posts: news_posts)
  end

  def show(conn, %{"slug" => slug}) do
    news_post = Blog.get_news_post_by_slug(slug)
    render(conn, "show.html", news_post: news_post)
  end
end
