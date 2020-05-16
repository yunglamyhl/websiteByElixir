defmodule PlangoraWeb.VideoPostView do
  use PlangoraWeb, :view

  alias Plangora.Multimedia.VideoPost

  def render_youtube_thumbnail(link) do
    case Regex.named_captures(VideoPost.video_regex(), link) do
      %{"youtube_id" => youtube_id} ->
        render_youtube_thumbnail_html(
          "https://img.youtube.com/vi/" <> youtube_id <> "/maxresdefault.jpg"
        )
    end
  end

  defp render_youtube_thumbnail_html(video_link),
    do: img_tag(video_link, height: "70%", width: "60%")

  def render_youtube_video(link) do
    case Regex.named_captures(VideoPost.video_regex(), link) do
      %{"youtube_id" => youtube_id} ->
        render_embed_video_html("https://www.youtube.com/embed/" <> youtube_id)
    end
  end

  defp render_embed_video_html(video_link),
    do: {:safe, ~s(<iframe class="embed-responsive-item" src="#{video_link}"
        allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
        allowfullscreen></iframe>)}

  def render_translation(en, nil, _locale), do: en
  def render_translation(_en, zh, "zh"), do: zh
  def render_translation(en, _zh, _locale), do: en
end
