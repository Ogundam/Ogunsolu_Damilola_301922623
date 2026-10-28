-- Fictional sample records for Sales Distribution Company: Sales and Distribution Management.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."customer" ("customer_id", "customer_name", "email", "billing_city") VALUES (101, 'Northstar Market', 'orders@northstar.example', 'Portland');
INSERT INTO portfolio."customer" ("customer_id", "customer_name", "email", "billing_city") VALUES (102, 'Cedar Supply', 'sales@cedarsupply.example', 'Denver');
INSERT INTO portfolio."product" ("product_id", "sku", "product_name", "list_price") VALUES (201, 'NS-100', 'Canvas Tote', 12.5);
INSERT INTO portfolio."product" ("product_id", "sku", "product_name", "list_price") VALUES (202, 'CS-200', 'Desk Organizer', 24);
INSERT INTO portfolio."sales_order" ("sales_order_id", "customer_id", "order_date", "status") VALUES (301, 101, '2026-03-10', 'confirmed');
INSERT INTO portfolio."sales_order" ("sales_order_id", "customer_id", "order_date", "status") VALUES (302, 102, '2026-03-12', 'draft');
INSERT INTO portfolio."order_line" ("order_line_id", "sales_order_id", "product_id", "line_number", "quantity", "agreed_unit_price") VALUES (401, 301, 201, 1, 4, 11.5);
INSERT INTO portfolio."order_line" ("order_line_id", "sales_order_id", "product_id", "line_number", "quantity", "agreed_unit_price") VALUES (402, 301, 202, 2, 2, 22);
INSERT INTO portfolio."order_line" ("order_line_id", "sales_order_id", "product_id", "line_number", "quantity", "agreed_unit_price") VALUES (403, 302, 201, 1, 3, 12);
COMMIT;
