# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :elm_articles,
  ecto_repos: [ElmArticles.Repo]

# Configures the endpoint
config :elm_articles, ElmArticles.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "MvkU4YUn+MgpUwI6Mcn+Acefdcs07xsrUaEmi+iZToXdh6AY4vtIkzsno6eez/po",
  render_errors: [view: ElmArticles.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ElmArticles.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
