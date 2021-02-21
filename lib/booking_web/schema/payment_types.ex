defmodule BookingWeb.Schema.PaymentTypes do
  use Absinthe.Schema.Notation

  @desc "payment for an order"
  object :payment do
    field :id, :id
    field :amount, :float
    field :applied_at, :datetime
    field :note, :string
  end
end
