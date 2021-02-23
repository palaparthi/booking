defmodule Booking.OrdersTest do
  use Booking.DataCase

  alias Booking.Orders

  describe "orders" do
    alias Booking.Orders.Order

    @valid_attrs %{description: "some description", total: 120.5}
    @invalid_attrs %{balance_due: nil, description: nil, total: nil}
    @valid_payment_amount 100.5
    @invalid_payment_amount 150

    def order_fixture(attrs \\ %{}) do
      {:ok, order} =
        attrs
        |> Enum.into(attrs)
        |> Orders.create_order()

      order
    end

    test "list_orders/0 returns all orders" do
      order = order_fixture(@valid_attrs)
      assert Orders.list_orders() == [order] |> Repo.preload(:payments_applied)
    end

    test "get_order/1 returns the order with given id" do
      order = order_fixture(@valid_attrs)
      assert Orders.get_order(order.id) == order
    end

    test "create_order/1 with valid data creates an order" do
      assert {:ok, %Order{} = order} = Orders.create_order(@valid_attrs)
      assert order.balance_due == 120.5
      assert order.description == "some description"
      assert order.total == 120.5
    end

    test "update_order_with_payment/2 with valid data updates an order" do
      order = order_fixture(@valid_attrs)

      assert {:ok, %Order{} = order} =
               Orders.update_order_with_payment(order, @valid_payment_amount)

      assert order.balance_due == 20
      assert order.description == "some description"
      assert order.total == 120.5
    end

    test "update_order_with_payment/2 with invalid data returns error changeset" do
      order = order_fixture(@valid_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Orders.update_order_with_payment(order, @invalid_payment_amount)
    end

    test "place_order_and_pay/2 with valid data updates an order" do
      assert {:ok, %Order{} = order} = Orders.place_order_and_pay(@valid_attrs, %{amount: 50})
      assert order.balance_due == 70.5
      assert order.description == "some description"
      assert order.total == 120.5
    end

    test "place_order_and_pay/2 with valid data creates an order" do
      assert {:ok, %Order{} = order} = Orders.place_order_and_pay(%{total: 0}, %{amount: 0})
      assert order.balance_due == 0
      assert order.total == 0
    end

    test "place_order_and_pay/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Orders.place_order_and_pay(@valid_attrs, %{amount: -10})
    end

    test "place_order_and_pay/2 with 0 total updates an order" do
      assert {:ok, %Order{} = order} = Orders.place_order_and_pay(@valid_attrs, %{amount: 50})
      assert order.balance_due == 70.5
      assert order.description == "some description"
      assert order.total == 120.5
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order(@invalid_attrs)
    end
  end
end
