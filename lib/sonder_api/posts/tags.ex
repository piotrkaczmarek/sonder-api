defmodule SonderApi.Posts.Tags do
  import Ecto.Query, warn: false
  alias SonderApi.Repo
  alias SonderApi.Posts.Tag
  alias SonderApi.Posts.PostTag


  def create_post_tags(post, tags) do
    Enum.map(tags, fn(tag) -> create_post_tag(post.id, tag.id) end)
  end

  def create_post_tag(post_id, tag_id) do
    %PostTag{}
    |> PostTag.changeset(%{post_id: post_id, tag_id: tag_id})
    |> Repo.insert()
  end

  def find_or_create_tags(tags) do
    Enum.map(tags, fn(tag) ->
      case tag do
        %{"id" => nil, "name" => name} -> find_or_create_tag(tag)
        %{"id" => id, "name" => name} -> %{id: id, name: name}
      end
    end)
  end

  def find_or_create_tag(tag) do
    case get_tag(%{name: tag["name"]}) do
      nil -> create_and_return_tag(tag)
      tag -> tag
    end
  end

  def get_tag(%{name: name}) do
    Repo.one(from tag in Tag, where: tag.name == ^name)
  end

  def create_tag(tag) do
    %Tag{}
    |> Tag.changeset(tag)
    |> Repo.insert()
  end

  def create_and_return_tag(tag) do
    {:ok, tag} = create_tag(tag)
    %{id: tag.id, name: tag.name}
  end

  def list_tags() do
    Repo.all(Tag)
  end

  def list_post_tags() do
    Repo.all(PostTag)
  end
end
