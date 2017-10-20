defmodule Todo.User.Worker do
	defstruct id: "",  name: "", password_hash: "", email: "", email_verfied: false, todos: %{}

	alias Todo.User.Worker

	def start_link() do
		Agent.start_link(fn -> %Worker{} end)
	end

	def initial_user(pid, id, name, email, password, todos) do
		Agent.update(pid, fn _state -> %Worker{id: id, name: name, email: email, password_hash: password, todos: todos} end)
	end

	def add_user(pid, id, name, email, password) do
		Agent.update(pid, fn _state -> %Worker{id: id, name: name, email: email, password_hash: password, todos: %{}} end)
	end

	def add_todo(pid, {id, description}) do
		Agent.update(pid, fn state -> Map.put(state, :todos, Map.put(state.todos, to_string(id), %{"description"=> description, "done"=> false})) end)
	end

	def update_todo(pid, id) do
		Agent.update(pid, fn state -> Map.put(state, :todos, Map.put(state.todos, to_string(id), Map.put(state.todos[to_string(id)], "done", !state.todos[to_string(id)]["done"]))) end)
	end

	def get_todos(pid) do
		Agent.get(pid, fn state -> state.todos end)
	end

	def get_current_user(pid) do
		Agent.get(pid, fn state -> {state.name, state.todos} end)
	end

	def get_user(pid) do
		Agent.get(pid, fn state -> state end)
	end

	def get_user_wo_pass(pid) do
		Agent.get(pid, fn state -> %{"name of user" => state.name, "todos" => state.todos} end)
	end
end