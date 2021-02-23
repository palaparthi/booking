# Booking

This project provides API for order management, using Elixir, GraphQL(Absinthe), PostgreSQL.

## Steps to run the project
  * Install docker and run `docker-compose build`
  * Run `docker-compose up`
  * Visit [`localhost:4040/api`](http://localhost:4040/api) from your browser after building
  
## Steps to run the tests
  Install Elixir, PostgreSQL and run `mix test`
  
## Key Features
   * All mutations are atomic
   * All IDs are UUIDs
   * Query to fetch all orders
   * Mutation to create an order
   * Mutation to apply a payment to an order
   * Subscriptions for all the above mutations
  
### TODOS
   * Make mutations idempotent i.e if the payment is submitted twice, charge only once.
   * Instead of preloading `paymentsApplied`, use Dataloader/Batching to load lazily. 