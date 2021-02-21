defmodule Booking.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias Booking.Payments.Payment

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "orders" do
    field :balance_due, :float
    field :description, :string
    field :total, :float
    has_many :payments_applied, Payment

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:description, :total, :balance_due])
    |> validate_required([:description, :total, :balance_due])
  end
end
