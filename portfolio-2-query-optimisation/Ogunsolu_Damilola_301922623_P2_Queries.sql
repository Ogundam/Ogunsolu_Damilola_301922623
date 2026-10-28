-- Show related sales_order, customer, order_line, product records (up to 20).
SELECT t0."sales_order_id" AS "sales_order_sales_order_id",
       t0."order_date" AS "sales_order_order_date",
       t3."customer_id" AS "customer_customer_id",
       t3."customer_name" AS "customer_customer_name",
       t1."order_line_id" AS "order_line_order_line_id",
       t1."line_number" AS "order_line_line_number",
       t2."product_id" AS "product_product_id",
       t2."sku" AS "product_sku"
FROM portfolio."sales_order" t0
JOIN portfolio."order_line" t1 ON t1."sales_order_id" = t0."sales_order_id"
JOIN portfolio."product" t2 ON t1."product_id" = t2."product_id"
JOIN portfolio."customer" t3 ON t0."customer_id" = t3."customer_id"
ORDER BY t0."sales_order_id", t3."customer_id", t1."order_line_id", t2."product_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."sales_order_id" AS "sales_order_sales_order_id",
       t0."order_date" AS "sales_order_order_date",
       t3."customer_id" AS "customer_customer_id",
       t3."customer_name" AS "customer_customer_name",
       t1."order_line_id" AS "order_line_order_line_id",
       t1."line_number" AS "order_line_line_number",
       t2."product_id" AS "product_product_id",
       t2."sku" AS "product_sku"
FROM portfolio."sales_order" t0
JOIN portfolio."order_line" t1 ON t1."sales_order_id" = t0."sales_order_id"
JOIN portfolio."product" t2 ON t1."product_id" = t2."product_id"
JOIN portfolio."customer" t3 ON t0."customer_id" = t3."customer_id"
ORDER BY t0."sales_order_id", t3."customer_id", t1."order_line_id", t2."product_id"
LIMIT 20;

-- Find sales_order records where order_date matches "2026-03-10" (up to 20).
SELECT * FROM portfolio."sales_order"
WHERE "order_date" IS NOT DISTINCT FROM '2026-03-10'
ORDER BY "sales_order_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."sales_order"
WHERE "order_date" IS NOT DISTINCT FROM '2026-03-10'
ORDER BY "sales_order_id"
LIMIT 20;

-- Count sales_order records for each customer_id (up to 20 groups).
SELECT "customer_id", count(*) AS record_count
FROM portfolio."sales_order"
GROUP BY "customer_id"
ORDER BY record_count DESC, "customer_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "customer_id", count(*) AS record_count
FROM portfolio."sales_order"
GROUP BY "customer_id"
ORDER BY record_count DESC, "customer_id" NULLS LAST
LIMIT 20;
