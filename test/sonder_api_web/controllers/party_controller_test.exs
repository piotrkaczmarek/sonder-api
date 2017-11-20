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

    test "returns all parties", %{conn: conn} do
      { :ok, [{ _, party_1}] } = create_party()
      { :ok, [{ _, party_2}] } = create_party()
      conn = get conn, party_path(conn, :index)
      serialized_parties = [party_1, party_2]
      |> Enum.map fn(party) -> %{"id" => party.id, "size" => party.size} end
      assert json_response(conn, 200)["data"] == serialized_parties
    end
  end

  describe "index when not authorized" do
    test "returns 401", %{conn: conn} do
      conn = get conn, party_path(conn, :index)

      assert json_response(conn, 401)["error"] == "Unauthorized"
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

  defp create_party() do
    party = fixture(:party)
    { :ok, party: party }
  end

  defp create_user_and_authorize(conn) do
    { user, token } = fixture(:user)
    conn = conn
    |> put_req_header("accesstoken", token)
    |> put_req_header("accept", "application/json")
    { :ok, conn: conn }
  end
end
