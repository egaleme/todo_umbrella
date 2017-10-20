defmodule Todo.Web.PageController do
  use Todo.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
