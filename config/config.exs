# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :dashwallet, DashwalletWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "gjZUWuguMFrYaRygLbME2rcHjA/rx2Of9OO42dlz4NSmfVw+xrCUqW3GXo2OA7+x",
  render_errors: [view: DashwalletWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Dashwallet.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
