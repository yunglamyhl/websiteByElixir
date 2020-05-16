defmodule PlangoraWeb.LiveViewCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Phoenix.ConnTest
      import Phoenix.LiveViewTest
      alias PlangoraWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint PlangoraWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Plangora.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Plangora.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
