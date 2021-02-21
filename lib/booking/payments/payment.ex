defmodule Booking.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Booking.Orders.Order

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "payments" do
    field :amount, :float
    field :applied_at, :utc_datetime_usec
    field :note, :string
    belongs_to :order, Order

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:amount, :applied_at, :note])
    |> validate_required([:amount, :applied_at, :note])
  end
end
