defmodule Plangora.Repo do
  use Ecto.Repo,
    otp_app: :plangora,
    adapter: Ecto.Adapters.Postgres

  def init(_, opts) do
    opts =
      opts
      |> Keyword.put(:url, System.get_env("DATABASE_URL"))
      |> Keyword.put(:prepare, database_prepare(System.get_env("DATABASE_PREPARE") || "unnamed"))
      |> Keyword.put(:ssl, !is_nil(System.get_env("DATABASE_SSL")))
      |> Keyword.put_new(:pool_size, String.to_integer(System.get_env("POOL_SIZE") || "20"))

    {:ok, opts}
  end

  defp database_prepare("unnamed"), do: :unnamed
  defp database_prepare(_), do: :named
end
