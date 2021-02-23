defmodule BookingWeb.Resolvers.Payments do
  @moduledoc """
  The Payments resolvers.
  """

  alias Booking.Payments

  def apply_payment_to_order(%{input: %{order_id: order_id}} = args, _resolution) do
    Payments.create_payment_for_order(order_id, args.input)
  end
end
