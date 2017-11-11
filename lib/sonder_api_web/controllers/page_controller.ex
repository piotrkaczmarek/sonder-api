defmodule SonderApiWeb.PageController do
  use SonderApiWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
