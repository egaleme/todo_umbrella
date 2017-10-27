defmodule Todo.User.TopSupervisor do
	use Supervisor

	def start_link do
		Supervisor.start_link __MODULE__, :ok, name: __MODULE__
	end

	def init(:ok) do
		children = [worker(Todo.User.UserServer, []),
				  supervisor(Todo.User.UserSupervisor, []),
				  supervisor(Todo.Todos.WorkerSupervisor, []),]

		supervise children, strategy: :one_for_one
	end
end