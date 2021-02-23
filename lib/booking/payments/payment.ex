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
  def changeset(%__MODULE__{} = payment, attrs) do
    payment
    |> cast(attrs, [:amount, :note])
    |> validate_required([:amount, :order])
    |> foreign_key_constraint(:order_id)
    |> put_change(:applied_at, DateTime.utc_now())
    |> validate_amount()
  end

  defp validate_amount(%Ecto.Changeset{data: %{order: order}} = changeset) do
    balance_due = Map.get(order || %{}, :balance_due)

    if balance_due == 0 do
      add_error(changeset, :amount, "Fully paid, no additional payment required")
    else
      validate_number(changeset, :amount, greater_than: 0, less_than_or_equal_to: balance_due)
    end
  end
end
