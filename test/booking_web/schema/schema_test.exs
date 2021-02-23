defmodule BookingWeb.Schema.SchemaTest do
  use BookingWeb.ConnCase, async: true

  @list_query """
  query ListOrders {
    orders {
      description
      balanceDue
      total
      paymentsApplied {
        amount
      }
    }
  }
  """

  @create_order_mutation """
    mutation CreateOrder($orderInput: OrderInput!) {
      createOrder(input: $orderInput) {
        successful
        messages {
          message
        }
        result {
          total
          description
        }
      }
    }
  """

  @create_order_and_pay_mutation """
    mutation OrderAndPay($orderInput: OrderInput!, $paymentInput: OrderPaymentInput!)  {
      createOrderAndPay(input: {orderInput: $orderInput, paymentInput: $paymentInput}) {
        successful
        messages {
          field
          message
        }
        result {
          balanceDue
        }
      }
    }
  """

  @create_order_mutation_with_id """
    mutation CreateOrder($orderInput: OrderInput!) {
      createOrder(input: $orderInput) {
        result {
          id
        }
      }
    }
  """

  @apply_payment_mutation """
    mutation ApplyPayment($paymentInput: PaymentInput!) {
      applyPaymentToOrder(input: $paymentInput) {
        successful
        messages {
          field
          message
        }
        result {
          amount
        }
      }
    }
  """

  describe "orders schema" do
    test "create order and list order valid" do
      input = %{description: "some description", total: 15.5}
      conn = build_conn()
      conn = post conn, "/api", query: @create_order_mutation, variables: %{"orderInput" => input}

      assert json_response(conn, 200) == %{
               "data" => %{
                 "createOrder" => %{
                   "messages" => [],
                   "result" => %{
                     "description" => "some description",
                     "total" => 15.5
                   },
                   "successful" => true
                 }
               }
             }

      conn = post conn, "/api", query: @list_query

      assert json_response(conn, 200) == %{
               "data" => %{
                 "orders" => [
                   %{
                     "balanceDue" => 15.5,
                     "description" => "some description",
                     "paymentsApplied" => [],
                     "total" => 15.5
                   }
                 ]
               }
             }
    end

    test "create order and pay valid" do
      conn = build_conn()

      conn =
        post conn, "/api",
          query: @create_order_and_pay_mutation,
          variables: %{"orderInput" => %{total: 10.5}, "paymentInput" => %{amount: 4.5}}

      assert json_response(conn, 200) == %{
               "data" => %{
                 "createOrderAndPay" => %{
                   "messages" => [],
                   "result" => %{"balanceDue" => 6.0},
                   "successful" => true
                 }
               }
             }
    end

    test "create order and pay invalid" do
      conn = build_conn()

      conn =
        post conn, "/api",
          query: @create_order_and_pay_mutation,
          variables: %{"orderInput" => %{total: 10}, "paymentInput" => %{amount: 11}}

      assert json_response(conn, 200) == %{
               "data" => %{
                 "createOrderAndPay" => %{
                   "messages" => [
                     %{"field" => "amount", "message" => "must be less than or equal to 10.0"}
                   ],
                   "result" => nil,
                   "successful" => false
                 }
               }
             }
    end
  end

  describe "payment" do
    setup do
      input = %{description: "some description", total: 15.5}
      conn = build_conn()

      conn =
        post conn, "/api",
          query: @create_order_mutation_with_id,
          variables: %{"orderInput" => input}

      order_id =
        json_response(conn, 200)
        |> Map.get("data")
        |> Map.get("createOrder")
        |> Map.get("result")
        |> Map.get("id")

      %{order_id: order_id}
    end

    test "apply payment to order valid", %{order_id: order_id} do
      conn = build_conn()

      conn =
        post conn, "/api",
          query: @apply_payment_mutation,
          variables: %{"paymentInput" => %{amount: 3, order_id: order_id}}

      assert json_response(conn, 200) == %{
               "data" => %{
                 "applyPaymentToOrder" => %{
                   "messages" => [],
                   "result" => %{"amount" => 3.0},
                   "successful" => true
                 }
               }
             }
    end

    test "apply multiple payment to order valid", %{order_id: order_id} do
      conn = build_conn()

      conn =
        post conn, "/api",
          query: @apply_payment_mutation,
          variables: %{"paymentInput" => %{amount: 10.5, order_id: order_id}}

      conn =
        post conn, "/api",
          query: @apply_payment_mutation,
          variables: %{"paymentInput" => %{amount: 5.0, order_id: order_id}}

      assert json_response(conn, 200) == %{
               "data" => %{
                 "applyPaymentToOrder" => %{
                   "messages" => [],
                   "result" => %{"amount" => 5.0},
                   "successful" => true
                 }
               }
             }
    end

    test "apply multiple payment to order invalid", %{order_id: order_id} do
      conn = build_conn()

      conn =
        post conn, "/api",
          query: @apply_payment_mutation,
          variables: %{"paymentInput" => %{amount: 10.5, order_id: order_id}}

      conn =
        post conn, "/api",
          query: @apply_payment_mutation,
          variables: %{"paymentInput" => %{amount: 5.5, order_id: order_id}}

      assert json_response(conn, 200) == %{
               "data" => %{
                 "applyPaymentToOrder" => %{
                   "messages" => [
                     %{"field" => "amount", "message" => "must be less than or equal to 5.0"}
                   ],
                   "result" => nil,
                   "successful" => false
                 }
               }
             }
    end
  end
end
