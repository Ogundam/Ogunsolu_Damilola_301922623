-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. reject customer pk. Expected: pk_customer, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "customer_name", "email", "billing_city")
VALUES (101, 'Alternate Buyer', 'alternate@example.test', 'Salem');

-- 2. reject customer email. Expected: uq_customer_0, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "customer_name", "email", "billing_city")
VALUES (1001, 'Alternate Buyer', 'orders@northstar.example', 'Salem');

-- 3. reject customer id null. Expected: customer_id, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "customer_name", "email", "billing_city")
VALUES (NULL, 'Null ID Buyer', 'nullid@example.test', 'Salem');

-- 4. reject customer name null. Expected: customer_name, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "customer_name", "email", "billing_city")
VALUES (1002, NULL, 'nullname@example.test', 'Salem');

-- 5. reject customer email null. Expected: email, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "customer_name", "email", "billing_city")
VALUES (1003, 'Null Email Buyer', NULL, 'Salem');

-- 6. reject customer city null. Expected: billing_city, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "customer_name", "email", "billing_city")
VALUES (1004, 'Null City Buyer', 'nullcity@example.test', NULL);

-- 7. reject product pk. Expected: pk_product, SQLSTATE 23505.
INSERT INTO portfolio."product" ("product_id", "sku", "product_name", "list_price")
VALUES (201, 'ALT-201', 'Alternate Product', 5);

-- 8. reject product sku. Expected: uq_product_0, SQLSTATE 23505.
INSERT INTO portfolio."product" ("product_id", "sku", "product_name", "list_price")
VALUES (1005, 'NS-100', 'Alternate Product', 5);

-- 9. reject product id null. Expected: product_id, SQLSTATE 23502.
INSERT INTO portfolio."product" ("product_id", "sku", "product_name", "list_price")
VALUES (NULL, 'NULL-ID', 'Null ID Product', 5);

-- 10. reject product sku null. Expected: sku, SQLSTATE 23502.
INSERT INTO portfolio."product" ("product_id", "sku", "product_name", "list_price")
VALUES (1006, NULL, 'Null SKU Product', 5);

-- 11. reject product name null. Expected: product_name, SQLSTATE 23502.
INSERT INTO portfolio."product" ("product_id", "sku", "product_name", "list_price")
VALUES (1007, 'NULL-NAME', NULL, 5);

-- 12. reject product price null. Expected: list_price, SQLSTATE 23502.
INSERT INTO portfolio."product" ("product_id", "sku", "product_name", "list_price")
VALUES (1008, 'NULL-PRICE', 'Null Price Product', NULL);

-- 13. reject sales order pk. Expected: pk_sales_order, SQLSTATE 23505.
INSERT INTO portfolio."sales_order" ("sales_order_id", "customer_id", "order_date", "status")
VALUES (301, 102, '2026-03-15', 'draft');

-- 14. reject sales order customer fk. Expected: fk_sales_order_0, SQLSTATE 23503.
INSERT INTO portfolio."sales_order" ("sales_order_id", "customer_id", "order_date", "status")
VALUES (1009, 99901, '2026-03-15', 'draft');

-- 15. reject sales order id null. Expected: sales_order_id, SQLSTATE 23502.
INSERT INTO portfolio."sales_order" ("sales_order_id", "customer_id", "order_date", "status")
VALUES (NULL, 101, '2026-03-15', 'draft');

-- 16. reject sales order customer null. Expected: customer_id, SQLSTATE 23502.
INSERT INTO portfolio."sales_order" ("sales_order_id", "customer_id", "order_date", "status")
VALUES (1010, NULL, '2026-03-15', 'draft');

-- 17. reject sales order date null. Expected: order_date, SQLSTATE 23502.
INSERT INTO portfolio."sales_order" ("sales_order_id", "customer_id", "order_date", "status")
VALUES (1011, 101, NULL, 'draft');

-- 18. reject sales order status null. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."sales_order" ("sales_order_id", "customer_id", "order_date", "status")
VALUES (1012, 101, '2026-03-15', NULL);

-- 19. reject sales order status check. Expected: order_status_allowed, SQLSTATE 23514.
INSERT INTO portfolio."sales_order" ("sales_order_id", "customer_id", "order_date", "status")
VALUES (1013, 101, '2026-03-15', 'pending');

-- 20. reject order line pk. Expected: pk_order_line, SQLSTATE 23505.
INSERT INTO portfolio."order_line" ("order_line_id", "sales_order_id", "product_id", "line_number", "quantity", "agreed_unit_price")
VALUES (401, 301, 202, 3, 1, 10);

-- 21. reject order line unique. Expected: uq_order_line_0, SQLSTATE 23505.
INSERT INTO portfolio."order_line" ("order_line_id", "sales_order_id", "product_id", "line_number", "quantity", "agreed_unit_price")
VALUES (1014, 301, 202, 1, 1, 10);

-- 22. reject order line order fk. Expected: fk_order_line_0, SQLSTATE 23503.
INSERT INTO portfolio."order_line" ("order_line_id", "sales_order_id", "product_id", "line_number", "quantity", "agreed_unit_price")
VALUES (1015, 99902, 202, 3, 1, 10);

-- 23. reject order line product fk. Expected: fk_order_line_1, SQLSTATE 23503.
INSERT INTO portfolio."order_line" ("order_line_id", "sales_order_id", "product_id", "line_number", "quantity", "agreed_unit_price")
VALUES (1016, 301, 99903, 3, 1, 10);

-- 24. reject order line id null. Expected: order_line_id, SQLSTATE 23502.
INSERT INTO portfolio."order_line" ("order_line_id", "sales_order_id", "product_id", "line_number", "quantity", "agreed_unit_price")
VALUES (NULL, 301, 202, 3, 1, 10);

-- 25. reject order line order null. Expected: sales_order_id, SQLSTATE 23502.
INSERT INTO portfolio."order_line" ("order_line_id", "sales_order_id", "product_id", "line_number", "quantity", "agreed_unit_price")
VALUES (1017, NULL, 202, 3, 1, 10);

-- 26. reject order line product null. Expected: product_id, SQLSTATE 23502.
INSERT INTO portfolio."order_line" ("order_line_id", "sales_order_id", "product_id", "line_number", "quantity", "agreed_unit_price")
VALUES (1018, 301, NULL, 3, 1, 10);

-- 27. reject order line number null. Expected: line_number, SQLSTATE 23502.
INSERT INTO portfolio."order_line" ("order_line_id", "sales_order_id", "product_id", "line_number", "quantity", "agreed_unit_price")
VALUES (1019, 301, 202, NULL, 1, 10);

-- 28. reject order line quantity null. Expected: quantity, SQLSTATE 23502.
INSERT INTO portfolio."order_line" ("order_line_id", "sales_order_id", "product_id", "line_number", "quantity", "agreed_unit_price")
VALUES (1020, 301, 202, 3, NULL, 10);

-- 29. reject order line price null. Expected: agreed_unit_price, SQLSTATE 23502.
INSERT INTO portfolio."order_line" ("order_line_id", "sales_order_id", "product_id", "line_number", "quantity", "agreed_unit_price")
VALUES (1021, 301, 202, 3, 1, NULL);

-- 30. reject order line positive check. Expected: order_line_positive_values, SQLSTATE 23514.
INSERT INTO portfolio."order_line" ("order_line_id", "sales_order_id", "product_id", "line_number", "quantity", "agreed_unit_price")
VALUES (1022, 301, 202, 3, 0, 10);
