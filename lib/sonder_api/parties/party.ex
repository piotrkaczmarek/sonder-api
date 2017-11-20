defmodule SonderApi.Parties.Party do
  use Ecto.Schema
  import Ecto.Changeset
  alias SonderApi.Parties.Party


  schema "parties" do
    field :size, :integer

    timestamps()
  end

  @doc false
  def changeset(%Party{} = party, attrs) do
    party
    |> cast(attrs, [:size])
    |> validate_required([:size])
  end
end
