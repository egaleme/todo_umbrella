defmodule Todo.User.UserSupervisor do
	use Supervisor

	def start_link do
		Supervisor.start_link __MODULE__, :ok, name: __MODULE__
	end

	def init(:ok) do
		child_processes = [worker(Todo.User.Worker, [])]
		supervise child_processes, strategy: :simple_one_for_one
	end

	def new_user() do
		Supervisor.start_child(__MODULE__, [])
	end
end