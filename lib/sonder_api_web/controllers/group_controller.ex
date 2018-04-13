defmodule SonderApiWeb.GroupController do
  use SonderApiWeb, :controller

  alias SonderApi.Groups
  alias SonderApi.Groups.Group
  alias SonderApi.Groups.UserGroup

  action_fallback SonderApiWeb.FallbackController

  def suggested(conn, _params) do
    groups = Groups.list_suggested_groups(conn.assigns[:current_user].id)
    render(conn, "index.json", groups: groups)
  end

  def accepted(conn, _params) do
    groups = Groups.list_accepted_groups(conn.assigns[:current_user].id)
    render(conn, "index.json", groups: groups)
  end

  def applicants(conn, %{"group_id" => group_id}) do
    with group <- Groups.get_user_group(%{user_id: conn.assigns[:current_user].id, group_id: group_id}),
        "accepted" <- group.state,
        applicants <- Groups.list_applicants(group_id)
    do
      render(conn, "people.json", people: applicants)
    end
  end

  def create(conn, %{"group" => group_params}) do
    with current_user_id <- conn.assigns[:current_user].id,
         {:ok, %Group{} = group} <- Groups.create_group(Map.merge(group_params, %{"owner_id" => current_user_id})),
         {:ok, %UserGroup{}} <- Groups.upsert_user_group(%{user_id: current_user_id,
                                                            group_id: group.id,
                                                            state: "accepted"})
    do
      conn
      |> put_status(:created)
      |> render("show.json", group: group)
    end
  end

  def apply(conn, %{"group_id" => group_id}) do
    with {:ok, %UserGroup{}} <- Groups.upsert_user_group(%{user_id: conn.assigns[:current_user].id,
                                                            group_id: group_id,
                                                            state: "applied"})
    do
      send_resp(conn, :no_content, "")
    end
  end

  def dismiss(conn, %{"group_id" => group_id}) do
    with {:ok, %UserGroup{}} <- Groups.upsert_user_group(%{user_id: conn.assigns[:current_user].id,
                                                            group_id: group_id,
                                                            state: "dismissed"})
    do
      send_resp(conn, :no_content, "")
    end
  end

  def accept(conn, %{"group_id" => group_id, "user_id" => user_id}) do
    with %Group{} = group <- Groups.get_group(%{owner_id: conn.assigns[:current_user].id, group_id: group_id}),
         {:ok, %UserGroup{}} <- Groups.upsert_user_group(%{user_id: user_id,
                                                            group_id: group_id,
                                                            state: "accepted"})
    do
      send_resp(conn, :no_content, "")
    end
  end

  def reject(conn, %{"group_id" => group_id, "user_id" => user_id}) do
    with %Group{} = group <- Groups.get_group(%{owner_id: conn.assigns[:current_user].id, group_id: group_id}),
         {:ok, %UserGroup{}} <- Groups.upsert_user_group(%{user_id: user_id,
                                                            group_id: group_id,
                                                            state: "rejected"})
    do
      send_resp(conn, :no_content, "")
    end
  end

  # def show(conn, %{"id" => id}) do
  #   group = Groups.get_group!(id)
  #   render(conn, "show.json", group: group)
  # end

  # def update(conn, %{"id" => id, "group" => group_params}) do
  #   group = Groups.get_group!(id)

  #   with {:ok, %Group{} = group} <- Groups.update_group(group, group_params) do
  #     render(conn, "show.json", group: group)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   group = Groups.get_group!(id)
  #   with {:ok, %Group{}} <- Groups.delete_group(group) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
