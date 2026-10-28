# Sales Distribution Company: Sales and Distribution Management — SQL queries

## 1. Show related sales_order, customer, order_line, product records (up to 20).

```sql
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
```

| sales_order_sales_order_id | sales_order_order_date | customer_customer_id | customer_customer_name | order_line_order_line_id | order_line_line_number | product_product_id | product_sku |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 301 | 2026-03-10 | 101 | Northstar Market | 401 | 1 | 201 | NS-100 |
| 301 | 2026-03-10 | 101 | Northstar Market | 402 | 2 | 202 | CS-200 |
| 302 | 2026-03-12 | 102 | Cedar Supply | 403 | 1 | 201 | NS-100 |

## 2. Find sales_order records where order_date matches "2026-03-10" (up to 20).

```sql
SELECT * FROM portfolio."sales_order"
WHERE "order_date" IS NOT DISTINCT FROM '2026-03-10'
ORDER BY "sales_order_id"
LIMIT 20;
```

| sales_order_id | customer_id | order_date | status |
| --- | --- | --- | --- |
| 301 | 101 | 2026-03-10 | confirmed |

## 3. Count sales_order records for each customer_id (up to 20 groups).

```sql
SELECT "customer_id", count(*) AS record_count
FROM portfolio."sales_order"
GROUP BY "customer_id"
ORDER BY record_count DESC, "customer_id" NULLS LAST
LIMIT 20;
```

| customer_id | record_count |
| --- | --- |
| 101 | 1 |
| 102 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.137 | 1.138, 1.137, 1.133 | Sort → Seq Scan | 139 |
| After index | 0.187 | 0.187, 0.203, 0.182 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 30 |

The median execution time changed from 1.137 ms to 0.187 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=1.112..1.113 rows=25 loops=1)
  Seq Scan on sales_order (actual time=0.014..1.075 rows=25 loops=1)
Planning Time: 0.325 ms
Execution Time: 1.138 ms
```

### Before index, run 2

```text
Sort (actual time=1.109..1.111 rows=25 loops=1)
  Seq Scan on sales_order (actual time=0.015..1.074 rows=25 loops=1)
Planning Time: 0.354 ms
Execution Time: 1.137 ms
```

### Before index, run 3

```text
Sort (actual time=1.106..1.108 rows=25 loops=1)
  Seq Scan on sales_order (actual time=0.014..1.073 rows=25 loops=1)
Planning Time: 0.328 ms
Execution Time: 1.133 ms
```

### After index, run 1

```text
Sort (actual time=0.142..0.144 rows=25 loops=1)
  Bitmap Heap Scan on sales_order (actual time=0.025..0.107 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.012..0.012 rows=25 loops=1)
Planning Time: 0.533 ms
Execution Time: 0.187 ms
```

### After index, run 2

```text
Sort (actual time=0.138..0.139 rows=25 loops=1)
  Bitmap Heap Scan on sales_order (actual time=0.025..0.101 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.012..0.012 rows=25 loops=1)
Planning Time: 0.535 ms
Execution Time: 0.203 ms
```

### After index, run 3

```text
Sort (actual time=0.137..0.139 rows=25 loops=1)
  Bitmap Heap Scan on sales_order (actual time=0.025..0.1 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.012..0.012 rows=25 loops=1)
Planning Time: 0.563 ms
Execution Time: 0.182 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Ogunsolu_Damilola_301922623_P2_Queries.sql, then Ogunsolu_Damilola_301922623_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Ogunsolu_Damilola_301922623_P2_QueryResults.png) · [Index comparison](screenshots/Ogunsolu_Damilola_301922623_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

