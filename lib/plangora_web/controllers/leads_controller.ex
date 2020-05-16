defmodule PlangoraWeb.LeadsController do
  use PlangoraWeb, :controller

  alias Plangora.Leads

  def index(conn, _) do
    leads = Leads.list_infos()
    render(conn, "index.html", leads: leads)
  end

  def show(conn, %{"id" => id}) do
    lead = Leads.get_info!(id)
    render(conn, "show.html", lead: lead)
  end

  def delete(conn, %{"id" => id}) do
    lead = Leads.get_info!(id)
    {:ok, _lead} = Leads.delete_info(lead)

    conn
    |> put_flash(:info, "Message deleted successfully.")
    |> redirect(to: Routes.leads_path(conn, :index))
  end
end
