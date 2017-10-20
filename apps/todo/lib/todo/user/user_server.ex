defmodule Todo.User.UserServer do
	use GenServer
	alias Todo.User.Account

	### Client API
	def start_link do
		GenServer.start_link __MODULE__, :ok, name: __MODULE__
	end

	def add_user(name, email, password) do
		GenServer.call(__MODULE__, {:add_user,name, email, password})
	end

	def get_users do
		GenServer.call(__MODULE__, {:get_users})
	end

	def add_todo(email, description) do
		GenServer.cast(__MODULE__, {:add_todo, email, description})
	end

	def login(email, password) do
		GenServer.call(__MODULE__, {:login, email, password})
	end

	def update_todo(email, id) do
		GenServer.cast(__MODULE__, {:update_todo, email, id})
	end

	def get_user(email) do
		GenServer.call(__MODULE__, {:get_user, email})
	end

	### Server API
	def init(:ok) do
		Process.send_after(self(), :process, 1000)
		{:ok, %{}}
	end

	def handle_info(:process, state) do
		users = Account.list_users
		state = Enum.reduce(users, state, fn(x, y) -> Map.put(y, x.email, get_pid(x)) end)
		{:noreply, state}
	end

	def handle_call({:add_user, name, email, password}, _from, state) do
		{:ok, pid} = Todo.User.UserSupervisor.new_user()
		{:ok, user} = Account.create_user(%{name: name, email: email, password: password, todos: %{}})
		Todo.User.Worker.add_user(pid, user.id, user.name, user.email, user.password_hash)
		state = Map.put(state, email, pid)
		user = Todo.User.Worker.get_user pid
		{:reply, {:ok, Map.from_struct(user)}, state}
	end

	def handle_call({:get_user, email}, _from, state) do
		pid = Map.get(state, email)
		user = Todo.User.Worker.get_user pid
		{:reply, user, state}
	end

	def handle_call({:get_users}, _from, state) do
		users = Enum.map(state, fn {_email, pid} -> Todo.User.Worker.get_user_wo_pass(pid) end)
		{:reply, users, state}
	end

	def handle_call({:login, email, password}, _from, state) do
		pid = Map.get(state, email)
		user = Todo.User.Worker.get_user(pid)
		status = Todo.Auth.UserAuth.login_by_password(password, user)
		{:reply, status, state}
	end

	def handle_cast({:update_todo, email, id}, state) do
		pid = Map.get(state, email)
		Todo.User.Worker.update_todo(pid, id)
		user = Todo.User.Worker.get_user(pid)
		Account.update_user(user.id, %{todos: user.todos})
		{:noreply, state}
	end

	def handle_cast({:add_todo, email, description}, state) do
		pid = Map.get(state, email)
		id = autoincrement(Todo.User.Worker.get_todos(pid))
		Todo.User.Worker.add_todo(pid, {id, description})
		user = Todo.User.Worker.get_user(pid)
		Account.update_user(user.id, %{todos: user.todos})
		{:noreply, state}
	end

	#### Helpers
	defp autoincrement(state) do
		state
		|> Kernel.map_size
		|> Kernel.+(1)
	end

	def get_pid(x) do
		{:ok, pid} = Todo.User.UserSupervisor.new_user()
		Todo.User.Worker.initial_user(pid, x.id, x.name, x.email, x.password_hash, x.todos)
		pid
	end
end