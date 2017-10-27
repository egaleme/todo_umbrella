defmodule Todo.Todos.Worker do
	defstruct description: "", done: false

	alias Todo.Todos.Worker

	def start_link() do
		Agent.start_link(fn-> %Worker{} end)
	end

	def add_state(pid, description, done) do
		Agent.update(pid, fn _state -> %Worker{description: description, done: done} end)
	end

	def get_state(pid) do
		Agent.get(pid, fn state -> to_map(state) end)
	end

	def update_state(pid) do
		Agent.update(pid, fn state -> Map.put(state, :done, !state.done) end)
	end

	def to_map(x) do
		%{
			"description" => x.description,
			"done" => x.done
		}
	end
end
