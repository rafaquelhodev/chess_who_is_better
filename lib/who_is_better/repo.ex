defmodule WhoIsBetter.Repo do
  use Ecto.Repo,
    otp_app: :who_is_better,
    adapter: Ecto.Adapters.Postgres
end
