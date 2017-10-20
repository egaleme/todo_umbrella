# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :todo_web,
  namespace: Todo.Web,
  ecto_repos: [Todo.Repo]

# Configures the endpoint
config :todo_web, Todo.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "cf4KVBOpcQYxnoCRx6KzpLfExfO1o5l5H0yaYIR866QLhE/11sUvuFw7QxLQquoX",
  render_errors: [view: Todo.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Todo.Web.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :todo_web, :generators,
  context_app: :todo

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
