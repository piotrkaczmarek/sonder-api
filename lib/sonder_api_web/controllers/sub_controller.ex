defmodule SonderApiWeb.SubController do
  use SonderApiWeb, :controller

  alias SonderApi.Subs
  alias SonderApi.Subs.Sub
  alias SonderApi.Subs.UserSub

  action_fallback SonderApiWeb.FallbackController

  def suggested(conn, _params) do
    subs = Subs.list_suggested_subs(conn.assigns[:current_user].id)
    render(conn, "index.json", subs: subs)
  end

  def accepted(conn, _params) do
    subs = Subs.list_accepted_subs(conn.assigns[:current_user].id)
    render(conn, "index.json", subs: subs)
  end

  def applicants(conn, %{"sub_id" => sub_id}) do
    with sub <- Subs.get_user_sub(%{user_id: conn.assigns[:current_user].id, sub_id: sub_id}),
        "accepted" <- sub.state,
        applicants <- Subs.list_applicants(sub_id)
    do
      render(conn, "people.json", people: applicants)
    end
  end

  def create(conn, %{"sub" => sub_params}) do
    with current_user_id <- conn.assigns[:current_user].id,
         {:ok, %Sub{} = sub} <- Subs.create_sub(Map.merge(sub_params, %{"owner_id" => current_user_id})),
         {:ok, %UserSub{}} <- Subs.upsert_user_sub(%{user_id: current_user_id,
                                                            sub_id: sub.id,
                                                            state: "accepted"})
    do
      conn
      |> put_status(:created)
      |> render("show.json", sub: sub)
    end
  end

  def apply(conn, %{"sub_id" => sub_id}) do
    with {:ok, %UserSub{}} <- Subs.upsert_user_sub(%{user_id: conn.assigns[:current_user].id,
                                                            sub_id: sub_id,
                                                            state: "applied"})
    do
      send_resp(conn, :no_content, "")
    end
  end

  def dismiss(conn, %{"sub_id" => sub_id}) do
    with {:ok, %UserSub{}} <- Subs.upsert_user_sub(%{user_id: conn.assigns[:current_user].id,
                                                            sub_id: sub_id,
                                                            state: "dismissed"})
    do
      send_resp(conn, :no_content, "")
    end
  end

  def accept(conn, %{"sub_id" => sub_id, "user_id" => user_id}) do
    with %Sub{} = sub <- Subs.get_sub(%{owner_id: conn.assigns[:current_user].id}),
         {:ok, %UserSub{}} <- Subs.upsert_user_sub(%{user_id: user_id,
                                                            sub_id: sub_id,
                                                            state: "accepted"})
    do
      send_resp(conn, :no_content, "")
    end
  end

  def reject(conn, %{"sub_id" => sub_id, "user_id" => user_id}) do
    with %Sub{} = sub <- Subs.get_sub(%{owner_id: conn.assigns[:current_user].id}),
         {:ok, %UserSub{}} <- Subs.upsert_user_sub(%{user_id: user_id,
                                                            sub_id: sub_id,
                                                            state: "rejected"})
    do
      send_resp(conn, :no_content, "")
    end
  end

  # def show(conn, %{"id" => id}) do
  #   sub = Subs.get_sub!(id)
  #   render(conn, "show.json", sub: sub)
  # end

  # def update(conn, %{"id" => id, "sub" => sub_params}) do
  #   sub = Subs.get_sub!(id)

  #   with {:ok, %Sub{} = sub} <- Subs.update_sub(sub, sub_params) do
  #     render(conn, "show.json", sub: sub)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   sub = Subs.get_sub!(id)
  #   with {:ok, %Sub{}} <- Subs.delete_sub(sub) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
