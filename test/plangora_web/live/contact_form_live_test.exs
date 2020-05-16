defmodule PlangoraWeb.ContactFormLiveTest do
  use PlangoraWeb.LiveViewCase, async: true
  @view PlangoraWeb.ContactFormLive

  test "can save message from contact form", %{conn: conn} do
    params = %{
      "info" => %{
        "name" => "name",
        "phone" => "12345678",
        "email" => "test@email.com",
        "message" => "message"
      }
    }

    {:ok, view, html} = live(conn, "/contact")

    assert html =~ "get a quote"
    assert render_submit(view, :send, params) =~ "Thank you for your comment."

    assert render_change(view, :validate, %{"info" => %{"phone" => "g"}}) =~
             "has invalid format"
  end
end
