defmodule Todo.Auth.UserAuth do
	#import Hasher

	def login_by_password(given_pass, user) do
		checkuser(user, given_pass)
	end

	defp checkuser(user, _given_pass) when user == nil do
		{:err, :notfound}
	end

	defp checkuser(user, given_pass) do
		chk = Hasher.check_password_hash(given_pass, user.password_hash)
		auth(user, user.email_verified, chk)
	end

# once you want email verification enabled, just change _true to true	

	defp auth(user, _true,  true), do: {:ok, user}
	defp auth(_user, _true,  false), do: {:err, :unauthorized}
#	defp auth(_, false, _), do: {:err, :notverified}
	
end
