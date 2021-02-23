defmodule Booking.Payments do
  @moduledoc """
  The Payments context.
  """
  import Ecto.Query, warn: false

  alias Booking.Repo
  alias Booking.Payments.Payment
  alias Booking.Orders

  @doc """
  Creates a payment for an order.

  ## Examples

      iex> create_payment_for_order(id, %{field: value})
      {:ok, %Payment{}}

      iex> create_payment_for_order(id, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_payment_for_order(order_id, attrs \\ %{}) do
    Repo.transaction(fn ->
      with order <- Orders.get_order(order_id),
           {:ok, %Payment{} = payment} <- do_create_payment_for_order(order, attrs),
           {:ok, _} <-
             Orders.update_order_with_payment(order, payment.amount) do
        payment
      else
        {:error, %Ecto.Changeset{} = changeset} -> Repo.rollback(changeset)
      end
    end)
  end

  @doc """
  insert a payment for an order.

  ## Examples

      iex> create_payment_for_order(id, %{field: value})
      {:ok, %Payment{}}

      iex> create_payment_for_order(id, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def do_create_payment_for_order(order, attrs) do
    %Payment{order: order}
    |> Payment.changeset(attrs)
    |> Repo.insert()
  end
end
