defmodule Booking.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias Booking.Repo

  alias Booking.Orders.Order
  alias Booking.Payments

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order) |> Repo.preload(:payments_applied)
  end

  @doc """
  Gets a single order.

  ## Examples

      iex> get_order(123)
      %Order{}

      iex> get_order(456)
      nil

  """
  def get_order(id), do: Repo.get(Order, id)

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order with payment.

  ## Examples

      iex> update_order_with_payment(%Order{}, 55)
      {:ok, %Order{}}

      iex> update_order(%Order{}, 55)
      {:error, %Ecto.Changeset{}}

  """
  def update_order_with_payment(%Order{} = order, payment_amount) do
    balance_due = order.balance_due - payment_amount

    order
    |> Order.changeset(%{balance_due: balance_due})
    |> Repo.update(returning: true)
  end

  @doc """
  Creates an order and a payment, when both order total and payment amount are 0, just creates an order and not a payment
  Note: when both are 0 the payment note is ignored since we are not adding payment row

  ## Examples

      iex> place_order_and_pay(%{total: 22}, %{amount: 2})
      {:ok, %Order{}}

      iex> update_order(%Order{}, 55)
      {:error, %Ecto.Changeset{}}

  """
  def place_order_and_pay(%{total: total} = order_attrs, %{amount: amount})
      when total == 0 and amount == 0,
      do: create_order(order_attrs)

  def place_order_and_pay(order_attrs, payment_attrs) do
    Repo.transaction(fn ->
      with {:ok, %Order{} = order} <- create_order(order_attrs),
           {:ok, %Payments.Payment{} = payment} <-
             Payments.do_create_payment_for_order(order, payment_attrs),
           {:ok, %Order{} = updated_order} <-
             update_order_with_payment(order, payment.amount) do
        updated_order |> Repo.preload(:payments_applied)
      else
        {:error, %Ecto.Changeset{} = changeset} -> Repo.rollback(changeset)
      end
    end)
  end
end
