defmodule Todo.Web.AuthChannel do
	use Todo.Web, :channel

	def join("auth", _payload, socket) do
		{:ok, socket}
	end

	def handle_in("login", %{"user" => %{"email" => email, "password" => password}}, socket) do
		case TodoEngine.login(email, password) do
			{:ok, user} ->
				jwt = Phoenix.Token.sign(Todo.Web.Endpoint, "user_salt", user.email)
				resp = %{access_token: jwt}
				push socket, "login", resp
				{:reply, {:ok, %{msg: jwt}}, socket}
			{:err, :notverified} ->
	        	{:reply, {:error, %{errors: "please verify your email address"}}, socket}
	      	{:err, :unauthorized} ->
	      	    {:reply, {:error, %{errors: "user password incorrect"}}, socket}
	        {:err, :notfound} ->
	       	    {:reply, {:error, %{errors: "user not found"}}, socket}
		end
	end

	def handle_in("register", %{"user" => %{"name" => name, "email" => email, "password" => password}}, socket) do
		case TodoEngine.register_user(name, email, password) do
			{:ok, user} ->
				{:reply, {:ok, user}, socket}
			_ ->
				{:reply, {:error, %{errors: "could not create user"}}, socket}
		end
	end
end