defmodule PlangoraWeb.ContactFormLive do
  use Phoenix.LiveView
  alias Plangora.Leads
  alias Plangora.Leads.Info

  def render(assigns) do
    Phoenix.View.render(PlangoraWeb.PageView, "new.html", assigns)
  end

  def mount(_, %{"locale" => locale}, socket) do
    Gettext.put_locale(locale)
    changeset = Leads.change_info(%Info{})
    {:ok, assign(socket, changeset: changeset, sent: false)}
  end

  #   "info" should be same as the module name
  def handle_event("validate", %{"info" => form_params}, socket) do
    changeset =
      %Info{}
      |> Leads.change_info(form_params)
      |> Map.put(:action, :create)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("send", %{"info" => form_params}, socket) do
    case Leads.create_info(form_params) do
      {:ok, _info} ->
        {:noreply,
         socket
         |> assign(:sent, true)}

      # |> put_flash(:info, "Success")}
      # |> redirect(to: Routes.page_path(socket, :new))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
