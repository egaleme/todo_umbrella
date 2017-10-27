defmodule Todo.User.Worker do
	defstruct id: "",  name: "", password_hash: "", email: "", email_verified: false, todos: %{}

	alias Todo.User.Worker

	def start_link() do
		Agent.start_link(fn -> %Worker{} end)
	end

	def initial_user(pid, id, name, email, password, todos) do
		Agent.update(pid, fn _state -> %Worker{id: id, name: name, email: email, password_hash: password, todos: reduce_todo(todos)} end)
	end

	def add_user(pid, id, name, email, password) do
		Agent.update(pid, fn _state -> %Worker{id: id, name: name, email: email, password_hash: password, todos: %{}} end)
	end

	def add_todo(pid, {id, description}) do
		Agent.update(pid, fn state -> Map.put(state, :todos, Map.put(state.todos, to_string(id), get_todo_pid(description, false))) end)
	end

	def update_todo(pid, id) do
		Agent.get(pid, fn state -> Map.get(state.todos, to_string(id))end) |> Todo.Todos.Worker.update_state
	end

	def get_todos(pid) do
		Agent.get(pid, fn state -> list_todos(state.todos) end)
	end

	def get_user(pid) do
		Agent.get(pid, fn state -> state end)
	end
	
	def get_user_wo_pass(pid) do
		Agent.get(pid, fn state -> %{"name of user" => state.name, "todos" => list_todos(state.todos)} end)
	end

	### Helpers

	defp list_todos(todos) do
		Enum.reduce(todos, %{}, fn{x, y}, p -> Map.put(p, x, Todo.Todos.Worker.get_state(y))end)
	end

	defp reduce_todo(todos) do
		Enum.reduce(todos, %{}, fn{x,y}, p -> Map.put(p, x, get_todo_pid(y["description"], y["done"])) end)
	end

	defp get_todo_pid(description, done) do
		{:ok, pid} = Todo.Todos.WorkerSupervisor.new_todo()
		Todo.Todos.Worker.add_state(pid, description, done)
		pid
	end

end