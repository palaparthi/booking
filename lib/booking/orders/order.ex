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
  def changeset(%__MODULE__{} = order, attrs) do
    order
    |> cast(attrs, [:description, :total, :balance_due])
    |> validate_required([:total])
    # total can be 0, in case of free order
    |> validate_number(:total, greater_than_or_equal_to: 0)
    |> maybe_add_balance_due()
    |> verify_balance_due()
  end

  defp maybe_add_balance_due(%Ecto.Changeset{} = changeset) do
    if get_field(changeset, :balance_due) do
      changeset
    else
      put_change(changeset, :balance_due, get_field(changeset, :total))
    end
  end

  defp verify_balance_due(%Ecto.Changeset{} = changeset) do
    balance_due = get_field(changeset, :balance_due)
    total = get_field(changeset, :total)

    cond do
      balance_due > total -> add_error(changeset, :balance_due, "Must be less than #{total}")
      balance_due < 0 -> add_error(changeset, :balance_due, "Must be greater than 0")
      true -> changeset
    end
  end
end
