defmodule Booking.OrdersTest do
  use Booking.DataCase
  import Booking.Factory

  alias Booking.Orders

  describe "orders" do
    alias Booking.Orders.Order

    @valid_attrs %{balance_due: 120.5, description: "some description", total: 120.5}
    @update_attrs %{balance_due: 456.7, description: "some updated description", total: 456.7}
    @invalid_attrs %{balance_due: nil, description: nil, total: nil}

    test "list_orders/0 returns all orders" do
      order = insert(:order, @valid_attrs)
      assert Orders.list_orders() == [order] |> Repo.preload(:payments_applied)
    end

    test "get_order!/1 returns the order with given id" do
      order = insert(:order, @valid_attrs)
      assert Orders.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      assert {:ok, %Order{} = order} = Orders.create_order(@valid_attrs)
      assert order.balance_due == 120.5
      assert order.description == "some description"
      assert order.total == 120.5
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = insert(:order, @valid_attrs)
      assert {:ok, %Order{} = order} = Orders.update_order(order, @update_attrs)
      assert order.balance_due == 456.7
      assert order.description == "some updated description"
      assert order.total == 456.7
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = insert(:order, @valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Orders.update_order(order, @invalid_attrs)
      assert order == Orders.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = insert(:order, @valid_attrs)
      assert {:ok, %Order{}} = Orders.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = insert(:order, @valid_attrs)
      assert %Ecto.Changeset{} = Orders.change_order(order)
    end
  end
end