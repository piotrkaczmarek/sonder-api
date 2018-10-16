defmodule SonderApiWeb.TagView do
  use SonderApiWeb, :view
  alias SonderApiWeb.TagView

  def render("index.json", %{tags: tags}) do
    %{data: render_many(tags, TagView, "tag.json")}
  end

  def render("tag.json", %{tag: tag}) do
    %{id: tag.id,
      name: tag.name}
  end
end
