defmodule PlangoraWeb.AdminNewsPostView do
  use PlangoraWeb, :view

  def render_image(link), do: img_tag(link, height: "80%", width: "50%", alt: "news_image")
end
