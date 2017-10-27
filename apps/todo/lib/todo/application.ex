defmodule Todo.Application do
  @moduledoc """
  The Todo Application Service.

  The todo system business domain lives in this application.

  Exposes API to clients such as the `Todo.Web` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(Todo.Repo, []),
      supervisor(Todo.User.TopSupervisor, []),
      supervisor(Todo.Todos.WorkerSupervisor, []),
    ], strategy: :one_for_one, name: Todo.Supervisor)
  end
end
