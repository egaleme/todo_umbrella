use Mix.Config

# Configure your database
config :todo, Todo.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "todo_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
