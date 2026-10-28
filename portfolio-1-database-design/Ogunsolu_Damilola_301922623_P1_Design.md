# Sales Distribution Company: Sales and Distribution Management — database design

My case study records customer, product, sales_order, order_line.

## Users

- Sales staff creating and reviewing customer orders
- Managers summarizing sales by customer and date

## Main operations

- Record a sales order for one customer
- Add product lines with quantities and agreed unit prices
- Review order details and summarize sales for a date range

## Entities

| Entity | Information stored |
| --- | --- |
| customer | A buyer that may place multiple sales orders. |
| product | A product that can appear on one or more order lines. |
| sales_order | An order header referencing one customer; it is the root of the stated normalization example. |
| order_line | A product entry on a sales order, storing the order-specific quantity and agreed unit price. |

## customer

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| customer_id | BIGINT | PK | Yes |
| customer_name | TEXT |  | Yes |
| email | TEXT | Unique | Yes |
| billing_city | TEXT |  | Yes |
- Unique key: (email).

## product

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| product_id | BIGINT | PK | Yes |
| sku | TEXT | Unique | Yes |
| product_name | TEXT |  | Yes |
| list_price | NUMERIC(18,2) |  | Yes |
- Unique key: (sku).

## sales_order

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| sales_order_id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| order_date | DATE |  | Yes |
| status | TEXT |  | Yes |
- customer_id → customer.customer_id

## order_line

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| order_line_id | BIGINT | PK | Yes |
| sales_order_id | BIGINT | FK | Yes |
| product_id | BIGINT | FK | Yes |
| line_number | INTEGER |  | Yes |
| quantity | INTEGER |  | Yes |
| agreed_unit_price | NUMERIC(18,2) |  | Yes |
- sales_order_id → sales_order.sales_order_id
- product_id → product.product_id
- Unique key: (sales_order_id, line_number).

## Relationships and business rules

- Each customer email identifies at most one customer.
- Each product SKU identifies at most one product.
- Every sales order references an existing customer.
- Every order line references an existing sales order.
- Every order line references an existing product.
- Order-line quantity and agreed unit price must both be greater than zero.
- A line number occurs at most once within a sales order; concurrent inserts must respect this rule.
- Order status is limited to the exercise's defined values: draft, confirmed, or cancelled.

## Assumptions

- All identifiers are globally unique single-column IDs, represented as UUID-like values.
- Each sales order belongs to exactly one customer; each order line belongs to exactly one sales order and one product.
- Unit price is the price agreed for that order line and is stored there rather than treated as the product's current price.
- For the normalization example, begin with a sales_order record containing customer name and address; move those customer attributes to customer and retain customer_id in sales_order. Keep product description in product and line quantity and agreed unit price in order_line.
- All dates and values used for examples and benchmarks are synthetic.

