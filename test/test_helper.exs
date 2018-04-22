{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.configure(timeout: :infinity)
ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(SonderApi.Repo, :manual)

