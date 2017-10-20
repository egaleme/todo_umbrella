defmodule Todo.Web.TodoChannel do
	use Todo.Web, :channel

	alias Todo.Web.Presence

	def join("todo", %{"access_token" => jwt}, socket) do
		case Phoenix.Token.verify(Todo.Web.Endpoint, "user_salt", jwt, max_age: 86400) do
			{:ok, user_email} ->
				send(self(), {:after_join, user_email})
				{:ok, socket}
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
end