defmodule Todo.Umbrella.Mixfile do
  use Mix.Project

  def project do
    [apps_path: "apps",
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options.
  #
  # Dependencies listed here are available only for this project
  # and cannot be accessed from applications inside the apps folder
defp deps do
    [{:phoenix, "~> 1.3.0"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.2"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:absinthe, "~> 1.3.1"},
     {:amnesia, "~> 0.2.5"},
     {:hasher, "~> 0.1.0"},
     {:absinthe_plug, "~> 1.3.0"},
     {:absinthe, "~> 1.3"},
     {:absinthe_ecto, "~> 0.1.0"},
     {:faker, "~> 0.7"},
     {:poison, "~> 2.0"},
     {:cors_plug, "~> 1.3"},
     {:ueberauth, "~> 0.4"},
     {:canary, "~> 1.1.1"},
     {:ueberauth_google, "~> 0.2"},
     {:ja_serializer, "~> 0.11.2"},
     {:ueberauth_facebook, "~> 0.6"},
     {:ueberauth_github, "~> 0.4"},
     {:ueberauth_identity, "~> 0.2"},
     {:ueberauth_google, "~> 0.2"},
     {:bamboo, "~> 0.7.0"},
     {:bamboo_smtp, "~> 1.2.1"},
     {:bodyguard, "~> 1.0.0"},
     {:secure_random, "~> 0.5.1"},
     {:oauth2, "~> 0.8.0"},
     {:guardian, "~> 0.14"},
     {:swoosh, "~> 0.8.1"},
     {:phoenix_swoosh, "~> 0.2"},
     {:gen_smtp, "~> 0.11.0"},
     {:gravatar, "~> 0.1.0"},
     {:exgravatar, "~> 2.0"},
     {:image64, "~> 0.0.2"},
     {:ecto_mnesia, "~> 0.9.0"},
     {:mix_docker, github: "Recruitee/mix_docker"},
     {:cloudini, "~> 1.2"}]
  end
end
