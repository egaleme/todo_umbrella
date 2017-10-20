use Mix.Config

# Configure your database
config :todo, Todo.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "200owina07",
  database: "todo_dev",
  hostname: "127.0.0.1",
  pool_size: 10
