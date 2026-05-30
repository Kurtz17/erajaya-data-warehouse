CREATE SCHEMA IF NOT EXISTS olap;

DROP TABLE IF EXISTS olap.mart_sales_overview CASCADE;
DROP TABLE IF EXISTS olap.agg_inventory_stockout CASCADE;
DROP TABLE IF EXISTS olap.agg_top_products CASCADE;
DROP TABLE IF EXISTS olap.agg_sales_by_region CASCADE;
DROP TABLE IF EXISTS olap.agg_sales_by_channel CASCADE;
DROP TABLE IF EXISTS olap.agg_monthly_sales CASCADE;

CREATE TABLE olap.agg_monthly_sales (
    year INTEGER,
    month INTEGER,
    total_sales NUMERIC(16,2),
    total_profit NUMERIC(16,2),
    total_quantity BIGINT,
    total_transactions BIGINT
);

CREATE TABLE olap.agg_sales_by_channel (
    channel_name VARCHAR(60),
    channel_type VARCHAR(30),
    total_sales NUMERIC(16,2),
    total_profit NUMERIC(16,2),
    total_transactions BIGINT
);

CREATE TABLE olap.agg_sales_by_region (
    province VARCHAR(80),
    city VARCHAR(80),
    total_sales NUMERIC(16,2),
    total_profit NUMERIC(16,2),
    total_transactions BIGINT
);

CREATE TABLE olap.agg_top_products (
    product_name VARCHAR(160),
    brand VARCHAR(60),
    category VARCHAR(60),
    total_quantity BIGINT,
    total_sales NUMERIC(16,2),
    total_profit NUMERIC(16,2)
);

CREATE TABLE olap.agg_inventory_stockout (
    store_name VARCHAR(160),
    city VARCHAR(80),
    product_name VARCHAR(160),
    brand VARCHAR(60),
    stock_quantity INTEGER,
    reorder_level INTEGER,
    stock_status VARCHAR(30)
);

CREATE TABLE olap.mart_sales_overview (
    transaction_id VARCHAR(20),
    detail_id VARCHAR(20),
    full_date DATE,
    year INTEGER,
    month INTEGER,
    customer_id VARCHAR(20),
    customer_name VARCHAR(120),
    loyalty_tier VARCHAR(30),
    customer_segment VARCHAR(60),
    product_id VARCHAR(20),
    product_name VARCHAR(160),
    brand VARCHAR(60),
    category VARCHAR(60),
    store_name VARCHAR(160),
    store_type VARCHAR(60),
    province VARCHAR(80),
    city VARCHAR(80),
    channel_name VARCHAR(60),
    channel_type VARCHAR(30),
    payment_method VARCHAR(60),
    payment_status VARCHAR(30),
    promotion_name VARCHAR(160),
    promotion_type VARCHAR(60),
    quantity_sold INTEGER,
    unit_price NUMERIC(14,2),
    gross_sales NUMERIC(14,2),
    discount_amount NUMERIC(14,2),
    net_sales NUMERIC(14,2),
    cost_amount NUMERIC(14,2),
    net_profit NUMERIC(14,2)
);
