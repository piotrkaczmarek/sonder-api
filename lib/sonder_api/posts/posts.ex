defmodule SonderApi.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias SonderApi.Repo

  alias SonderApi.Posts.Post
  alias SonderApi.Posts.Comment
  alias SonderApi.Posts.Vote
  alias SonderApi.Posts.Tag
  alias SonderApi.Posts.PostTag
  alias SonderApi.Posts.Tags

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

 @doc """
  Returns the list of posts posted to given group.

  ## Examples

      iex> get_group_posts(5, 1)
      [%Post{}, ...]

  """
  def get_group_posts(%{group_id: group_id}) do
    Repo.all(from post in Post,
             where: post.group_id == ^group_id,
             order_by: [desc: post.points])
  end

  def get_group_posts(%{group_ids: group_ids, page: page, per_page: per_page}) do
    query = from post in Post,
            #  where: post.group_id in ^group_ids,
            order_by: [desc: post.points]
    Repo.paginate(query, page: page, page_size: per_page)
  end

  def get_group_tag_posts(%{group_ids: group_ids, tags: tags, page: page, per_page: per_page}) do
    query = from post in Post,
            #  where: post.group_id in ^group_ids,
            join: post_tag in PostTag, where: post_tag.tag_id in ^tags and post_tag.post_id == post.id,
            order_by: [desc: post.points]
    Repo.paginate(query, page: page, page_size: per_page)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Gets a single post.

  Returns nil if the Post does not exist.

  ## Examples

      iex> get_post(123)
      %Post{}

      iex> get_post(456)
      nil

  """
  def get_post(id) when is_integer(id), do: Repo.get(Post, id)
  def get_post(id) when is_bitstring(id), do: Repo.get(Post, id)

  def get_post(%{post_id: post_id}) do
    Repo.one(from post in Post,
             where: post.id == ^post_id)
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def create_post_with_tags(%{post: post_attrs, tags: tags}) do
    with {:ok, %Post{} = post} <- create_post(post_attrs),
         tags <- Tags.find_or_create_tags(tags),
         _ <- Tags.create_post_tags(post, tags)
    do
      {:ok, post}
    end
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end

  @doc """
  Calculates post's points and updates it.

  ## Examples

      iex> update_post_points(post)
      {:ok, %Post{}}

  """
  def update_post_points(%Post{} = post) do
    query = from vote in Vote,
            where: vote.post_id == ^post.id and is_nil(vote.comment_id)
    points = Repo.aggregate(query, :sum, :points)
    update_post(post, %{points: points})
  end


  @doc """
  Calculates comment's points and updates it.

  ## Examples

      iex> update_comment_points(post)
      {:ok, %Post{}}

  """
  def update_comment_points(%Comment{} = comment) do
    query = from vote in Vote,
            where: vote.post_id == ^comment.post_id and vote.comment_id == ^comment.id
    points = Repo.aggregate(query, :sum, :points)
    update_comment(comment, %{points: points})
  end


  @doc """
  Returns the list of votes.

  ## Examples

      iex> list_votes()
      [%Vote{}, ...]

  """
  def list_votes do
    Repo.all(Vote)
  end

  def get_user_post_votes(%{voter_id: voter_id}) do
    query = from vote in Vote,
            where: vote.voter_id == ^voter_id and
                   is_nil(vote.comment_id)
    Repo.all(query)
  end

  def get_user_comment_votes(%{voter_id: voter_id, post_id: post_id}) do
    query = from vote in Vote,
            where: vote.voter_id == ^voter_id and
                   vote.post_id == ^post_id and
                   not is_nil(vote.comment_id)
    Repo.all(query)
  end


  @doc """
  Gets a single vote.

  Raises `Ecto.NoResultsError` if the Vote does not exist.

  ## Examples

      iex> get_vote!(123)
      %Vote{}

      iex> get_vote!(456)
      ** (Ecto.NoResultsError)

  """
  def get_vote!(id), do: Repo.get!(Vote, id)

  def get_vote(%{post_id: post_id, comment_id: comment_id, voter_id: voter_id}) do
    Repo.one(from vote in Vote,
             where: vote.post_id == ^post_id and
                    vote.comment_id == ^comment_id and
                    vote.voter_id == ^voter_id)
  end

  def get_vote(%{post_id: post_id, voter_id: voter_id}) do
    Repo.one(from vote in Vote,
             where: vote.post_id == ^post_id and
                    is_nil(vote.comment_id) and
                    vote.voter_id == ^voter_id)
  end

  @doc """
  Gets a single vote.

  Returns nil if the Vote does not exist.

  ## Examples

      iex> get_vote(123)
      %Vote{}

      iex> get_vote(456)
      nil

  """
  def get_vote(id), do: Repo.get(Vote, id)


  @doc """
  Creates a vote.

  ## Examples

      iex> create_vote(%{field: value})
      {:ok, %Vote{}}

      iex> create_vote(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_vote(attrs \\ %{}) do
    %Vote{}
    |> Vote.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates or updates vote.

  ## Examples

      iex> upsert_vote(%{field: value})
      {:ok, %Vote{}}

      iex> upsert_vote(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def upsert_vote(attrs = %{post_id: post_id, comment_id: comment_id, voter_id: voter_id, points: points}) do
    case get_vote(%{post_id: post_id, comment_id: comment_id, voter_id: voter_id}) do
      %Vote{} = vote -> update_vote(vote, attrs)
      nil -> create_vote(attrs)
    end
  end

  def upsert_vote(attrs = %{post_id: post_id, voter_id: voter_id, points: points}) do
    case get_vote(%{post_id: post_id, voter_id: voter_id}) do
      %Vote{} = vote -> update_vote(vote, attrs)
      nil -> create_vote(attrs)
    end
  end


  @doc """
  Updates a vote.

  ## Examples

      iex> update_vote(vote, %{field: new_value})
      {:ok, %Vote{}}

      iex> update_vote(vote, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_vote(%Vote{} = vote, attrs) do
    vote
    |> Vote.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Vote.

  ## Examples

      iex> delete_vote(vote)
      {:ok, %Vote{}}

      iex> delete_vote(vote)
      {:error, %Ecto.Changeset{}}

  """
  def delete_vote(%Vote{} = vote) do
    Repo.delete(vote)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vote changes.

  ## Examples

      iex> change_vote(vote)
      %Ecto.Changeset{source: %Vote{}}

  """
  def change_vote(%Vote{} = vote) do
    Vote.changeset(vote, %{})
  end

  alias SonderApi.Posts.Comment

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Gets a single comment.

  Returns nil if the Comment does not exist.

  ## Examples

      iex> get_comment(123)
      %Comment{}

      iex> get_comment(456)
      nil

  """
  def get_comment(id), do: Repo.get(Comment, id)

  def get_comments(%{post_id: post_id}) do
    Repo.all(from comment in Comment,
             where: comment.post_id == ^post_id)
  end

  def get_comment_count(%{post_id: post_id}) do
    Repo.one(from c in Comment,
             where: c.post_id == ^post_id,
             select: count("*"))
  end

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{source: %Comment{}}

  """
  def change_comment(%Comment{} = comment) do
    Comment.changeset(comment, %{})
  end
end
