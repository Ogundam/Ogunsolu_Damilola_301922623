# Sales Distribution Company: Sales and Distribution Management — ER diagram

```mermaid
erDiagram
    direction LR
    customer {
        bigint customer_id PK
        text customer_name
        text email UK
        text billing_city
    }
    product {
        bigint product_id PK
        text sku UK
        text product_name
        numeric list_price
    }
    sales_order {
        bigint sales_order_id PK
        bigint customer_id FK
        date order_date
        text status
    }
    order_line {
        bigint order_line_id PK
        bigint sales_order_id FK
        bigint product_id FK
        integer line_number
        integer quantity
        numeric agreed_unit_price
    }
    customer ||--o{ sales_order : "customer_id"
    sales_order ||--o{ order_line : "sales_order_id"
    product ||--o{ order_line : "product_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Ogunsolu_Damilola_301922623_ERDiagram.png)
