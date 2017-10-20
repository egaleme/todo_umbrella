defmodule Todo.User.User do
	use Ecto.Schema
	import Ecto.Changeset
	alias Todo.User.User

	schema "users" do
		field :name, :string
		field :email, :string
		field :password, :string, virtual: true
		field :password_hash, :string
		field :email_verified, :boolean
		field :todos, :map

		timestamps()
	end

	def todos_changeset(%User{} = user, params) do
		user
		|> cast(params, [:todos])
	end

	def changeset(%User{} = user, params) do
		user
		|> cast(params, [:name, :email, :todos])
		|> validate_required([:name, :email])
		|> validate_format(:email, ~r/@/)
		|> unique_constraint(:email)
		|> put_not_verified()
	end

	defp put_not_verified(changeset) do
		case changeset do
			%Ecto.Changeset{valid?: true} -> 
				put_change(changeset, :email_verified, false)
			_ ->
				changeset
		end
	end

	def registration_changeset(model, params \\ %{}) do
		model
		|> changeset(params)
		|> cast(params, [:password])
		|> validate_length(:password, min: 4, max: 200)
		|> put_hash()		
	end

	defp put_hash(changeset) do
		case changeset do
			%Ecto.Changeset{valid?: true, changes: %{password: password}} ->
				put_change(changeset, :password_hash, Hasher.salted_password_hash(password))
			_ ->
				changeset
		end
	end
end