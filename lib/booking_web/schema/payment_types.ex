defmodule BookingWeb.Schema.PaymentTypes do
  use Absinthe.Schema.Notation

  alias BookingWeb.Resolvers.Payments

  import AbsintheErrorPayload.Payload

  @desc "Payment for an order"
  object :payment do
    field :id, :id
    field :amount, :float
    field :applied_at, :datetime
    field :note, :string
  end

  @desc "Input for an order"
  input_object :payment_input do
    field :order_id, non_null(:id)
    field :amount, non_null(:float)
    field :note, :string
  end

  payload_object(:payment_payload, :payment)

  # mutations
  object :payment_mutations do
    @desc "Apply a payment to an order"
    field :apply_payment_to_order, :payment_payload do
      arg(:input, non_null(:payment_input))
      resolve(&Payments.apply_payment_to_order/2)
      middleware(&build_payload/2)
    end
  end
end
