defmodule BookingWeb.Resolvers.Orders do
  @moduledoc """
  The Orders resolvers.
  """

  alias Booking.Orders

  def list_orders(_parent, _args, _resolution) do
    {:ok, Orders.list_orders()}
  end

  def create_order(args, _resolution) do
    Orders.create_order(args.input)
  end

  def place_order_and_pay(args, _resolution) do
    Orders.place_order_and_pay(args.input.order_input, args.input.payment_input)
  end
end
