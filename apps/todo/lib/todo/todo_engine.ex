defmodule TodoEngine do

	def register_user(name, email, password) do
		Todo.User.UserServer.add_user(name, email, password)
	end

	def login(email, password) do
		Todo.User.UserServer.login(email, password)
	end

	def add_todo(email, description) do
		Todo.User.UserServer.add_todo(email, description)
	end

	def update_todo(email, id) do
		Todo.User.UserServer.update_todo(email, id)
	end

	def list_users do
		Todo.User.UserServer.get_users
	end

	def get_user(email) do
		Todo.User.UserServer.get_user email
	end
end
