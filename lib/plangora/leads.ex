defmodule Plangora.Leads do
  import Ecto.Query, warn: false
  alias Plangora.Repo

  alias Plangora.Leads.Info

  def list_infos do
    Repo.all(Info)
  end

  def get_info!(id), do: Repo.get!(Info, id)

  def create_info(attrs) do
    %Info{}
    |> Info.changeset(attrs)
    |> Repo.insert()
  end

  def delete_info(%Info{} = info) do
    Repo.delete(info)
  end

  def change_info(%Info{} = info, attrs \\ %{}) do
    Info.changeset(info, attrs)
  end
end
