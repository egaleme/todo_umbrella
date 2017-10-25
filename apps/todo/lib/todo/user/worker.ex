defmodule Todo.User.Worker do
	defstruct id: "",  name: "", password_hash: "", email: "", email_verified: false, todos: []

	alias Todo.User.Worker

	def start_link() do
		Agent.start_link(fn -> %Worker{} end)
	end

	def initial_user(pid, id, name, email, password, todos) do
		Agent.update(pid, fn _state -> %Worker{id: id, name: name, email: email, password_hash: password, todos: to_list(todos)} end)
	end

	def add_user(pid, id, name, email, password) do
		Agent.update(pid, fn _state -> %Worker{id: id, name: name, email: email, password_hash: password, todos: []} end)
	end

	def add_todo(pid, {id, description}) do
		Agent.update(pid, fn state -> Map.put(state, :todos, [%{"id" => to_string(id), "description" => description, "done" => false} | state.todos]) end)
	end

	def update_todo(pid, id) do
		Agent.update(pid, fn state -> Map.put(state, :todos, list_to_map(state.todos) |> update_map(id) |> map_list) end)
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

	### Helpers

	defp to_list(list) do
		Enum.map(list, fn({x, p}) -> %{"id" => x, "description" => p["description"], "done" => p["done"]} end)
	end

	defp list_to_map(todos) do
		Enum.reduce(todos, %{}, fn(x, y)-> Map.put(y, to_string(x["id"]), %{"description" => x["description"], "done" => x["done"]}) end)
	end

	defp update_map(todos, id) do
		 Map.put(todos, to_string(id), Map.put(todos[to_string(id)], "done", !todos["done"]))
	end

	defp map_list(b) do
		 Enum.reduce(b, [], fn({x, y}, p) -> [%{"id" => x, "description" => y["description"], "done" => y["done"]}|p] end)
	end

end