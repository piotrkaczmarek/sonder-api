defmodule SonderApiWeb.PartyControllerTest do
  use SonderApiWeb.ConnCase

  alias SonderApi.Parties
  alias SonderApi.Parties.Party
  alias SonderApi.Accounts

  @create_attrs %{size: 42}
  @update_attrs %{size: 43}
  @invalid_attrs %{size: nil}

  def fixture(:party) do
    {:ok, party} = Parties.create_party(@create_attrs)
    party
  end

  def fixture(:user) do
    token = "123456"
    {:ok, user } = Accounts.create_user(%{first_name: "Bob", email: "test@example.com", facebook_access_token: token, facebook_id: "1234"})
    { user, token }
  end

  describe "index when authorized" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "returns empty array when there are no parties", %{conn: conn} do
      conn = get conn, party_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end

    test "returns all parties with users", %{conn: conn} do
      party_1 = create_party()
      party_2 = create_party()
      user_1 = create_user(%{email: "email1@example.com", facebook_access_token: "abc", facebook_id: "123", first_name: "Bob"})
      user_2 = create_user(%{email: "email2@example.com", facebook_access_token: "bcd", facebook_id: "234", first_name: "Susan"})

      create_user_party(%{user_id: user_1.id, party_id: party_1.id, state: "accepted"})
      create_user_party(%{user_id: user_1.id, party_id: party_2.id, state: "accepted"})
      create_user_party(%{user_id: user_2.id, party_id: party_1.id, state: "accepted"})

      conn = get conn, party_path(conn, :index)

      expected_response = [
        %{"id" => party_1.id,
          "size" => party_1.size,
          "members" => [%{"id" => user_1.id, "first_name" => user_1.first_name}, %{"id" => user_2.id, "first_name" => user_2.first_name}]},
        %{"id" => party_2.id,
          "size" => party_2.size,
          "members" => [%{"id" => user_1.id, "first_name" => user_1.first_name}]}
      ]

      assert json_response(conn, 200)["data"] == expected_response
    end
  end

  describe "index when not authorized" do
    test "returns 401", %{conn: conn} do
      conn = get conn, party_path(conn, :index)

      assert json_response(conn, 401)["error"] == "Unauthorized"
    end
  end

  describe "request" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "creates user_party with state 'requested'", %{conn: conn} do
      party = create_party()

      conn = put(conn, "/api/parties/#{party.id}/request")
      assert conn.status, "204"

      [user_party] = Parties.list_user_parties
      assert conn.assigns[:current_user].id == user_party.user_id
      assert user_party.state == "requested"
    end
  end

  describe "dismiss" do
    setup %{conn: conn}, do: create_user_and_authorize(conn)

    test "creates user_party with state 'dismissed'", %{conn: conn} do
      party = create_party()

      conn = put(conn, "/api/parties/#{party.id}/dismiss")
      assert conn.status, "204"

      [user_party] = Parties.list_user_parties
      assert conn.assigns[:current_user].id == user_party.user_id
      assert user_party.state == "dismissed"
    end
  end
  # describe "create party" do
  #   test "renders party when data is valid", %{conn: conn} do
  #     conn = post conn, party_path(conn, :create), party: @create_attrs
  #     assert %{"id" => id} = json_response(conn, 201)["data"]

  #     conn = get conn, party_path(conn, :show, id)
  #     assert json_response(conn, 200)["data"] == %{
  #       "id" => id,
  #       "size" => 42}
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post conn, party_path(conn, :create), party: @invalid_attrs
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "update party" do
  #   setup [:create_party]

  #   test "renders party when data is valid", %{conn: conn, party: %Party{id: id} = party} do
  #     conn = put conn, party_path(conn, :update, party), party: @update_attrs
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get conn, party_path(conn, :show, id)
  #     assert json_response(conn, 200)["data"] == %{
  #       "id" => id,
  #       "size" => 43}
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, party: party} do
  #     conn = put conn, party_path(conn, :update, party), party: @invalid_attrs
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete party" do
  #   setup [:create_party]

  #   test "deletes chosen party", %{conn: conn, party: party} do
  #     conn = delete conn, party_path(conn, :delete, party)
  #     assert response(conn, 204)
  #     assert_error_sent 404, fn ->
  #       get conn, party_path(conn, :show, party)
  #     end
  #   end
  # end

  def create_party(attrs \\ %{}) do
    {:ok, party} =
      attrs
      |> Enum.into(%{size: 4})
      |> Parties.create_party()

    party
  end

  defp create_user(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{email: "email@example.com", facebook_access_token: "some facebook_access_token", facebook_id: "some facebook_id", first_name: "some first_name"})
      |> SonderApi.Accounts.create_user()

    user
  end

  defp create_user_party(attrs \\ %{}) do
    {:ok, user_party} =
      attrs
      |> Parties.create_user_party()

    user_party
  end

  defp create_user_and_authorize(conn) do
    { user, token } = fixture(:user)
    conn = conn
    |> put_req_header("accesstoken", token)
    |> put_req_header("accept", "application/json")
    { :ok, conn: conn }
  end
end
