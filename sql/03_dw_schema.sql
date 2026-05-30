CREATE SCHEMA IF NOT EXISTS dw;

DROP TABLE IF EXISTS dw.fact_inventory_snapshot CASCADE;
DROP TABLE IF EXISTS dw.fact_sales CASCADE;
DROP TABLE IF EXISTS dw.dim_promotion CASCADE;
DROP TABLE IF EXISTS dw.dim_payment CASCADE;
DROP TABLE IF EXISTS dw.dim_channel CASCADE;
DROP TABLE IF EXISTS dw.dim_store CASCADE;
DROP TABLE IF EXISTS dw.dim_product CASCADE;
DROP TABLE IF EXISTS dw.dim_customer CASCADE;
DROP TABLE IF EXISTS dw.dim_time CASCADE;

CREATE TABLE dw.dim_time (
    time_key INTEGER PRIMARY KEY,
    full_date DATE NOT NULL UNIQUE,
    year INTEGER NOT NULL,
    quarter INTEGER NOT NULL,
    month INTEGER NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    day INTEGER NOT NULL,
    day_of_week VARCHAR(20) NOT NULL,
    is_weekend BOOLEAN NOT NULL
);

CREATE TABLE dw.dim_customer (
    customer_key INTEGER PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL UNIQUE,
    customer_name VARCHAR(120) NOT NULL,
    gender VARCHAR(20),
    birth_date DATE,
    loyalty_tier VARCHAR(30),
    customer_segment VARCHAR(60),
    province VARCHAR(80),
    city VARCHAR(80),
    registered_date DATE
);

CREATE TABLE dw.dim_product (
    product_key INTEGER PRIMARY KEY,
    product_id VARCHAR(20) NOT NULL UNIQUE,
    product_name VARCHAR(160) NOT NULL,
    brand VARCHAR(60) NOT NULL,
    category VARCHAR(60) NOT NULL,
    subcategory VARCHAR(60),
    unit_price NUMERIC(14,2),
    cost_price NUMERIC(14,2),
    launch_date DATE,
    is_active BOOLEAN
);

CREATE TABLE dw.dim_store (
    store_key INTEGER PRIMARY KEY,
    store_id VARCHAR(20) NOT NULL UNIQUE,
    store_name VARCHAR(160) NOT NULL,
    store_type VARCHAR(60),
    province VARCHAR(80),
    city VARCHAR(80),
    region VARCHAR(80),
    open_date DATE
);

CREATE TABLE dw.dim_channel (
    channel_key INTEGER PRIMARY KEY,
    channel_id VARCHAR(20) NOT NULL UNIQUE,
    channel_name VARCHAR(60) NOT NULL,
    channel_type VARCHAR(30) NOT NULL
);

CREATE TABLE dw.dim_payment (
    payment_key INTEGER PRIMARY KEY,
    payment_id VARCHAR(20) NOT NULL UNIQUE,
    payment_method VARCHAR(60) NOT NULL,
    payment_status VARCHAR(30) NOT NULL,
    payment_provider VARCHAR(80)
);

CREATE TABLE dw.dim_promotion (
    promotion_key INTEGER PRIMARY KEY,
    promotion_id VARCHAR(20) NOT NULL UNIQUE,
    promotion_name VARCHAR(160) NOT NULL,
    promotion_type VARCHAR(60) DEFAULT 'No Promotion',
    discount_rate NUMERIC(6,4),
    start_date DATE,
    end_date DATE
);

CREATE TABLE dw.fact_sales (
    sales_key BIGINT PRIMARY KEY,
    transaction_id VARCHAR(20) NOT NULL,
    detail_id VARCHAR(20) NOT NULL UNIQUE,
    time_key INTEGER NOT NULL REFERENCES dw.dim_time(time_key),
    customer_key INTEGER NOT NULL REFERENCES dw.dim_customer(customer_key),
    product_key INTEGER NOT NULL REFERENCES dw.dim_product(product_key),
    store_key INTEGER NOT NULL REFERENCES dw.dim_store(store_key),
    channel_key INTEGER NOT NULL REFERENCES dw.dim_channel(channel_key),
    payment_key INTEGER NOT NULL REFERENCES dw.dim_payment(payment_key),
    promotion_key INTEGER NOT NULL REFERENCES dw.dim_promotion(promotion_key),
    quantity_sold INTEGER NOT NULL,
    unit_price NUMERIC(14,2) NOT NULL,
    gross_sales NUMERIC(14,2) NOT NULL,
    discount_amount NUMERIC(14,2) NOT NULL,
    net_sales NUMERIC(14,2) NOT NULL,
    cost_amount NUMERIC(14,2) NOT NULL,
    net_profit NUMERIC(14,2) NOT NULL
);

CREATE TABLE dw.fact_inventory_snapshot (
    inventory_key BIGINT PRIMARY KEY,
    time_key INTEGER NOT NULL REFERENCES dw.dim_time(time_key),
    product_key INTEGER NOT NULL REFERENCES dw.dim_product(product_key),
    store_key INTEGER NOT NULL REFERENCES dw.dim_store(store_key),
    stock_quantity INTEGER NOT NULL,
    reorder_level INTEGER NOT NULL,
    stock_status VARCHAR(30) NOT NULL
);

