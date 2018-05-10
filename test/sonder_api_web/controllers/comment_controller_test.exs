defmodule SonderApiWeb.CommentControllerTest do
  use SonderApiWeb.ConnCase

  alias SonderApi.Posts
  alias SonderApi.Posts.Comment

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
    create_user_and_authorize(conn)
  end

  describe "index" do
    test "lists all comments", %{conn: conn, user: current_user} do
      group = insert(:group)
      insert(:user_group, %{user: current_user, group: group, state: "accepted"})
      post = insert(:post, %{group: group})
      conn = get conn, comment_path(conn, :index, post.id)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create comment" do
    test "renders comment when data is valid", %{conn: conn, user: current_user} do
      group = insert(:group)
      insert(:user_group, %{user: current_user, group: group, state: "accepted"})
      post = insert(:post, %{group: group})
      c = build(:comment, %{post: post})
      attrs = %{body: c.body, post_id: c.post_id, author_id: c.author_id, parent_ids: c.parent_ids}
      conn = post conn, comment_path(conn, :create, post.id), comment: attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      [comment | _] = Posts.list_comments()
      assert comment.id == id
    end

    test "renders errors when data is invalid", %{conn: conn, user: current_user} do
      group = insert(:group)
      insert(:user_group, %{user: current_user, group: group, state: "accepted"})
      post = insert(:post, %{group: group})
      conn = post conn, comment_path(conn, :create, post.id), comment: %{bad: "stuff"}
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  # describe "update comment" do
  #   setup [:create_comment]

  #   test "renders comment when data is valid", %{conn: conn, comment: %Comment{id: id} = comment} do
  #     conn = put conn, comment_path(conn, :update, comment), comment: @update_attrs
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get conn, comment_path(conn, :show, id)
  #     assert json_response(conn, 200)["data"] == %{
  #       "id" => id}
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, comment: comment} do
  #     conn = put conn, comment_path(conn, :update, comment), comment: @invalid_attrs
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete comment" do
  #   setup [:create_comment]

  #   test "deletes chosen comment", %{conn: conn, comment: comment} do
  #     conn = delete conn, comment_path(conn, :delete, comment)
  #     assert response(conn, 204)
  #     assert_error_sent 404, fn ->
  #       get conn, comment_path(conn, :show, comment)
  #     end
  #   end
  # end

  defp create_user_and_authorize(conn) do
    user = insert(:user)
    {:ok, encoded_token, _claims} = SonderApi.Guardian.encode_and_sign(user)
    conn = conn
    |> put_req_header("authorization", encoded_token)
    |> put_req_header("accept", "application/json")
    { :ok, conn: conn, user: user }
  end
end
