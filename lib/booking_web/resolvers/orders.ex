defmodule BookingWeb.Resolvers.Orders do
  @moduledoc """
  The Orders resolvers.
  """

  alias Booking.Orders

  def list_orders(_parent, _args, _resolution) do
    {:ok, Orders.list_orders()}
  end
end
