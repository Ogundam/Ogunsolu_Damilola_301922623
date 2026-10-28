-- Sales Distribution Company: Sales and Distribution Management: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."customer" (
  "customer_id" bigint NOT NULL,
  "customer_name" text NOT NULL,
  "email" text NOT NULL,
  "billing_city" text NOT NULL,
  CONSTRAINT "pk_customer" PRIMARY KEY ("customer_id"),
  CONSTRAINT "uq_customer_0" UNIQUE ("email")
);
CREATE TABLE portfolio."product" (
  "product_id" bigint NOT NULL,
  "sku" text NOT NULL,
  "product_name" text NOT NULL,
  "list_price" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_product" PRIMARY KEY ("product_id"),
  CONSTRAINT "uq_product_0" UNIQUE ("sku")
);
CREATE TABLE portfolio."sales_order" (
  "sales_order_id" bigint NOT NULL,
  "customer_id" bigint NOT NULL,
  "order_date" date NOT NULL,
  "status" text NOT NULL,
  CONSTRAINT "pk_sales_order" PRIMARY KEY ("sales_order_id")
);
CREATE TABLE portfolio."order_line" (
  "order_line_id" bigint NOT NULL,
  "sales_order_id" bigint NOT NULL,
  "product_id" bigint NOT NULL,
  "line_number" bigint NOT NULL,
  "quantity" bigint NOT NULL,
  "agreed_unit_price" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_order_line" PRIMARY KEY ("order_line_id"),
  CONSTRAINT "uq_order_line_0" UNIQUE ("sales_order_id", "line_number")
);
ALTER TABLE portfolio."sales_order" ADD CONSTRAINT "fk_sales_order_0" FOREIGN KEY ("customer_id") REFERENCES portfolio."customer" ("customer_id");
ALTER TABLE portfolio."order_line" ADD CONSTRAINT "fk_order_line_0" FOREIGN KEY ("sales_order_id") REFERENCES portfolio."sales_order" ("sales_order_id");
ALTER TABLE portfolio."order_line" ADD CONSTRAINT "fk_order_line_1" FOREIGN KEY ("product_id") REFERENCES portfolio."product" ("product_id");
ALTER TABLE portfolio."order_line" ADD CONSTRAINT "order_line_positive_values" CHECK (("quantity" > 0) AND ("agreed_unit_price" > 0));
ALTER TABLE portfolio."sales_order" ADD CONSTRAINT "order_status_allowed" CHECK (("status" = 'draft') OR ("status" = 'confirmed') OR ("status" = 'cancelled'));
COMMIT;
