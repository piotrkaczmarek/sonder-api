defmodule SonderApiWeb.PostView do
  use SonderApiWeb, :view
  alias SonderApiWeb.PostView
  alias SonderApiWeb.CommentView
  alias SonderApi.Posts

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, PostView, "post.json")}
  end

  def render("paginated_index.json", %{posts: posts, page: page}) do
    %{data: render_many(posts, PostView, "post.json"),
      page: page.page_number,
      perPage: page.page_size,
      totalEntries: page.total_entries,
      totalPages: page.total_pages
    }
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{id: post.id,
      title: post.title,
      body: post.body,
      authorId: post.author_id,
      points: post.points
    }
  end
end
