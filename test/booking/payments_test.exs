#defmodule Booking.PaymentsTest do
#  use Booking.DataCase
#  import Booking.Factory
#
#  describe "payments" do
#    alias Booking.Payments.Payment
#
#    setup do
#      order = insert(:order)
#
#      {:ok, order: order}
#    end
#
#    @valid_attrs %{amount: 120.5, applied_at: "2010-04-17T14:00:00.000000Z", note: "some note"}
#    @update_attrs %{amount: 456.7, applied_at: "2011-05-18T15:01:01.000000Z", note: "some updated note"}
#    @invalid_attrs %{amount: nil, applied_at: nil, note: nil}
#
#    def payment_fixture(attrs \\ %{}) do
#      {:ok, payment} =
#        attrs
#        |> Enum.into(@valid_attrs)
#        |> Orders.create_payment()
#
#      payment
#    end
#
#    test "list_payments/0 returns all payments" do
#      payment = payment_fixture()
#      assert Orders.list_payments() == [payment]
#    end
#
#    test "get_payment!/1 returns the payment with given id" do
#      payment = payment_fixture()
#      assert Orders.get_payment!(payment.id) == payment
#    end
#
#    test "create_payment/1 with valid data creates a payment" do
#      assert {:ok, %Payment{} = payment} = Orders.create_payment(@valid_attrs)
#      assert payment.amount == 120.5
#      assert payment.applied_at == DateTime.from_naive!(~N[2010-04-17T14:00:00.000000Z], "Etc/UTC")
#      assert payment.note == "some note"
#    end
#
#    test "create_payment/1 with invalid data returns error changeset" do
#      assert {:error, %Ecto.Changeset{}} = Orders.create_payment(@invalid_attrs)
#    end
#
#    test "update_payment/2 with valid data updates the payment" do
#      payment = payment_fixture()
#      assert {:ok, %Payment{} = payment} = Orders.update_payment(payment, @update_attrs)
#      assert payment.amount == 456.7
#      assert payment.applied_at == DateTime.from_naive!(~N[2011-05-18T15:01:01.000000Z], "Etc/UTC")
#      assert payment.note == "some updated note"
#    end
#
#    test "update_payment/2 with invalid data returns error changeset" do
#      payment = payment_fixture()
#      assert {:error, %Ecto.Changeset{}} = Orders.update_payment(payment, @invalid_attrs)
#      assert payment == Orders.get_payment!(payment.id)
#    end
#
#    test "delete_payment/1 deletes the payment" do
#      payment = payment_fixture()
#      assert {:ok, %Payment{}} = Orders.delete_payment(payment)
#      assert_raise Ecto.NoResultsError, fn -> Orders.get_payment!(payment.id) end
#    end
#
#    test "change_payment/1 returns a payment changeset" do
#      payment = payment_fixture()
#      assert %Ecto.Changeset{} = Orders.change_payment(payment)
#    end
#  end
#
#end