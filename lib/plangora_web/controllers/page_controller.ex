defmodule PlangoraWeb.PageController do
  use PlangoraWeb, :controller

  alias Plangora.Multimedia
  alias Plangora.Blog

  def index(conn, _) do
    latest_videos = Multimedia.list_recent_video_posts()
    latest_news = Blog.list_recent_news_posts()
    render(conn, "index.html", latest_videos: latest_videos, latest_news: latest_news)
  end

  def new(%{assigns: %{locale: locale}} = conn, _params) do
    live_render(conn, PlangoraWeb.ContactFormLive, session: %{"locale" => locale})
  end
end
