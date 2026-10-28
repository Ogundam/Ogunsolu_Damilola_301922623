# Sales Distribution Company: Sales and Distribution Management — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| customer_id | sales_order records (list) |
| --- | --- |
| 101 | [301] |
| 102 | [302] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| sales_order.sales_order_id | sales_order.customer_id | sales_order.status | customer.customer_id | customer.customer_name |
| --- | --- | --- | --- | --- |
| 301 | 101 | confirmed | 101 | Northstar Market |
| 302 | 102 | draft | 102 | Cedar Supply |

Key: sales_order_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## sales_order_example

| sales_order.sales_order_id | sales_order.customer_id | sales_order.status | customer.customer_id | customer.customer_name |
| --- | --- | --- | --- | --- |
| 301 | 101 | confirmed | 101 | Northstar Market |
| 302 | 102 | draft | 102 | Cedar Supply |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## customer

| customer_id | customer_name | email | billing_city |
| --- | --- | --- | --- |
| 101 | Northstar Market | orders@northstar.example | Portland |
| 102 | Cedar Supply | sales@cedarsupply.example | Denver |

## product

| product_id | sku | product_name | list_price |
| --- | --- | --- | --- |
| 201 | NS-100 | Canvas Tote | 12.5 |
| 202 | CS-200 | Desk Organizer | 24 |

## sales_order

| sales_order_id | customer_id | order_date | status |
| --- | --- | --- | --- |
| 301 | 101 | 2026-03-10 | confirmed |
| 302 | 102 | 2026-03-12 | draft |

## order_line

| order_line_id | sales_order_id | product_id | line_number | quantity | agreed_unit_price |
| --- | --- | --- | --- | --- | --- |
| 401 | 301 | 201 | 1 | 4 | 11.5 |
| 402 | 301 | 202 | 2 | 2 | 22 |
| 403 | 302 | 201 | 1 | 3 | 12 |

## Dependencies

- customer: (customer_id) → customer_name, email, billing_city
- product: (product_id) → sku, product_name, list_price
- sales_order: (sales_order_id) → customer_id, order_date, status
- order_line: (order_line_id) → sales_order_id, product_id, line_number, quantity, agreed_unit_price

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
