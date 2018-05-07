defmodule SonderApi.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias SonderApi.Repo

  alias SonderApi.Posts.Post
  alias SonderApi.Posts.Comment

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
    |> Repo.preload(:users)
  end

 @doc """
  Returns the list of posts posted to given group.

  ## Examples

      iex> get_group_posts(5, 1)
      [%Post{}, ...]

  """
  def get_group_posts(%{group_id: group_id, current_user_id: current_user_id}) do
    Repo.all(from post in Post,
             where: post.group_id == ^group_id,
             left_join: v in assoc(post, :votes),
             on: v.voter_id == ^current_user_id and is_nil(v.comment_id),
             preload: [votes: v])
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
  def get_post(id), do: Repo.get(Post, id)

  def get_post_with_comments(%{post_id: post_id}) do
    Repo.one(from post in Post,
             where: post.id == ^post_id,
             left_join: c in assoc(post, :comments),
             preload: [comments: c])
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

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
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

  alias SonderApi.Posts.Vote

  @doc """
  Returns the list of votes.

  ## Examples

      iex> list_votes()
      [%Vote{}, ...]

  """
  def list_votes do
    Repo.all(Vote)
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

  def get_vote(%{post_id: post_id, comment_id: comment_id}) do
    Repo.one(from v in Vote, where: v.post_id == ^post_id and v.comment_id == ^comment_id)
  end

  def get_vote(%{post_id: post_id}) do
    Repo.one(from v in Vote, where: v.post_id == ^post_id)
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
  def upsert_vote(attrs = %{post_id: post_id, comment_id: comment_id, points: points}) do
    case get_vote(%{post_id: post_id, comment_id: comment_id}) do
      %Vote{} = vote -> update_vote(vote, attrs)
      nil -> create_vote(attrs)
    end
  end

  def upsert_vote(attrs = %{post_id: post_id, points: points}) do
    case get_vote(%{post_id: post_id}) do
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
end
