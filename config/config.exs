# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sonder_api,
  ecto_repos: [SonderApi.Repo]

# Configures the endpoint
config :sonder_api, SonderApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TZMEGuvh+pUlDScObu/iknXrugUIegkiz60N+DAB/QKfJYqMrZ1qx+O9kcsBgJBV",
  render_errors: [view: SonderApiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SonderApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :sonder_api, SonderApi.Guardian,
       issuer: "sonder_api",
       secret_key: "oRtoBAvy7Chq2EYZBHrpvYWJoAojG70q0TXdqcjC1FQkWbhiCu/0x92/ZVrhT2sx" # mix guardian.gen.secret
