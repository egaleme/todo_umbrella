defmodule Todo.Web.TodoChannel do
	use Todo.Web, :channel

	alias Todo.Web.Presence

	def join("todo", %{"access_token" => jwt}, socket) do
		case Phoenix.Token.verify(Todo.Web.Endpoint, "user_salt", jwt, max_age: 86400) do
			{:ok, user_email} ->
				
				send(self(), {:after_join, user_email})
				{:ok, assign(socket, :email, user_email)}
			{:error, _} ->
				{:reply, {:error, %{errors: "incorrect login credentials"}}, socket}
		end
	end

	def handle_info({:after_join, user_email}, socket) do
		
		{:ok, _} = Presence.track(socket, user_email, %{
			online_at: inspect(System.system_time(:seconds))
			})

		{:noreply, socket}
	end

	def handle_in("show_users", _payload, socket) do
		broadcast! socket, "users", Presence.list(socket)
		{:noreply, socket}
	end

	def handle_in("add_todo", %{"description" => description}, socket) do
		email = socket.assigns.email
		TodoEngine.add_todo(email, description)
		{:noreply, socket}
	end

	def handle_in("update_todo", %{"id" => id}, socket) do
		email = socket.assigns.email
		TodoEngine.update_todo(email, id)
		{:noreply, socket}
	end

	def handle_in("get_user_todos", _payload, socket) do
		email = socket.assigns.email
		todos = TodoEngine.get_todos(email)
		push socket, "get_todos", %{todos: todos}
		{:noreply, socket}
	end
end