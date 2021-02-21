defmodule BookingWeb.Schema.OrderTypes do
  use Absinthe.Schema.Notation

  @desc "order"
  object :order do
    field :id, :id
    field :balance_due, :float
    field :description, :string
    field :total, :float
    field :payments_applied, list_of(:payment)
  end
end
