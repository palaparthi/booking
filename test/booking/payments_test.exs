defmodule Booking.PaymentsTest do
  use Booking.DataCase

  alias Booking.Payments

  describe "payments" do
    alias Booking.Payments.Payment

    @valid_attrs %{amount: 120.5, note: "some note"}
    @valid_order_attrs %{total: 120.5, description: "some description"}
    @update_attrs %{amount: 456.7, note: "some updated note"}
    @invalid_attrs %{amount: nil, note: nil}

    def order_fixture(attrs \\ %{}) do
      {:ok, order} =
        attrs
        |> Enum.into(attrs)
        |> Booking.Orders.create_order()

      order
    end

    test "create_payment_for_order/2 with valid data creates a payment" do
      order = order_fixture(@valid_order_attrs)

      assert {:ok, %Payment{} = payment} =
               Payments.create_payment_for_order(order.id, @valid_attrs)

      new_order = Booking.Orders.get_order(payment.order_id)
      assert payment.amount == 120.5
      assert new_order.balance_due == 0
    end

    test "create_payment_for_order/2 with invalid data return an error changeset" do
      order = order_fixture(@valid_order_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Payments.create_payment_for_order(order.id, @invalid_attrs)
    end

    test "create_payment_for_order/2 with greater amount return an error changeset" do
      order = order_fixture(@valid_order_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Payments.create_payment_for_order(order.id, %{amount: 130})
    end

    test "create_payment_for_order/2 with negative amount return an error changeset" do
      order = order_fixture(@valid_order_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Payments.create_payment_for_order(order.id, %{amount: -1})
    end

    test "do_create_payment_for_order/2 with valid data creates a payment" do
      order = order_fixture(@valid_order_attrs)

      assert {:ok, %Payment{} = payment} =
               Payments.do_create_payment_for_order(order, @valid_attrs)

      assert payment.amount == 120.5
    end

    test "do_create_payment_for_order/2 with invalid data return an error changeset" do
      order = order_fixture(@valid_order_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Payments.do_create_payment_for_order(order, @invalid_attrs)
    end

    test "do_create_payment_for_order/2 with greater amount return an error changeset" do
      order = order_fixture(@valid_order_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Payments.do_create_payment_for_order(order, %{amount: 130})
    end

    test "do_create_payment_for_order/2 with negative amount return an error changeset" do
      order = order_fixture(@valid_order_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Payments.do_create_payment_for_order(order, %{amount: -1})
    end
  end
end
