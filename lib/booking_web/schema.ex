defmodule BookingWeb.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(BookingWeb.Schema.OrderTypes)
  import_types(BookingWeb.Schema.PaymentTypes)

  alias BookingWeb.Resolvers

  query do
    @desc "Get all orders"
    field :orders, list_of(:order) do
      resolve(&Resolvers.Orders.list_orders/3)
    end
  end
end
