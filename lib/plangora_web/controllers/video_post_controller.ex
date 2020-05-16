defmodule PlangoraWeb.VideoPostController do
  use PlangoraWeb, :controller

  alias Plangora.Multimedia

  def index(conn, params) do
    video_posts = Multimedia.list_video_posts(params)
    render(conn, "index.html", video_posts: video_posts)
  end

  def show(conn, %{"slug" => slug}) do
    video_post = Multimedia.get_video_post_by_slug(slug)
    render(conn, "show.html", video_post: video_post)
  end
end
