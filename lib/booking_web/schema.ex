defmodule BookingWeb.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(BookingWeb.Schema.OrderTypes)
  import_types(BookingWeb.Schema.PaymentTypes)
  import_types(AbsintheErrorPayload.ValidationMessageTypes)

  query do
    import_fields(:order_queries)
  end

  mutation do
    import_fields(:order_mutations)
    import_fields(:payment_mutations)
  end
end
