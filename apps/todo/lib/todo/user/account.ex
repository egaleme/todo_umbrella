defmodule Todo.User.Account do
  import Ecto.Query, warn: false
  alias Todo.Repo

  alias Todo.User.User

  def list_users do
  	Repo.all(User)
  end

  def create_user(attrs \\ %{}) do
  	%User{}
  	|> User.registration_changeset(attrs)
  	|> Repo.insert()
  end

  def update_user(user_id, attrs) do
    user = Repo.get!(User, user_id)
    user
    |> User.todos_changeset(attrs)
    |> Repo.update()
  end
end