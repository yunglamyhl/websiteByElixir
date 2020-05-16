defmodule PlangoraWeb.NewsPostView do
  use PlangoraWeb, :view

  def render_image(link), do: img_tag(link, height: "70%", width: "60%")

  def render_translation(en, nil, _locale), do: en
  def render_translation(_en, zh, "zh"), do: zh
  def render_translation(en, _zh, _locale), do: en
end
