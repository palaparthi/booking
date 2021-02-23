defmodule BookingWeb.Schema.OrderTypes do
  use Absinthe.Schema.Notation

  alias BookingWeb.Resolvers.Orders

  import AbsintheErrorPayload.Payload

  @desc "An order"
  object :order do
    field :id, :id
    field :balance_due, :float
    field :description, :string
    field :total, :float
    field :payments_applied, list_of(:payment)
  end

  @desc "Input for an order"
  input_object :order_input do
    field :total, non_null(:float)
    field :description, :string
  end

  @desc "Input for order and pay"
  input_object :order_payment_input do
    field :amount, non_null(:float)
    field :note, :string
  end

  @desc "Input for order & pay"
  input_object :order_and_pay_input do
    field :order_input, non_null(:order_input)
    field :payment_input, non_null(:order_payment_input)
  end

  payload_object(:order_payload, :order)

  # queries
  object :order_queries do
    @desc "Get all orders"
    field :orders, list_of(:order) do
      resolve(&Orders.list_orders/3)
    end
  end

  # mutations
  object :order_mutations do
    @desc "Create an order"
    field :create_order, :order_payload do
      arg(:input, non_null(:order_input))
      resolve(&Orders.create_order/2)
      middleware(&build_payload/2)
    end

    @desc "Create an order and pay"
    field :create_order_and_pay, :order_payload do
      arg(:input, non_null(:order_and_pay_input))
      resolve(&Orders.place_order_and_pay/2)
      middleware(&build_payload/2)
    end
  end
end
