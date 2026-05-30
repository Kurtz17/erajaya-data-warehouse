CREATE SCHEMA IF NOT EXISTS oltp;

DROP TABLE IF EXISTS oltp.tb_inventory CASCADE;
DROP TABLE IF EXISTS oltp.tb_sales_detail CASCADE;
DROP TABLE IF EXISTS oltp.tb_sales_transaction CASCADE;
DROP TABLE IF EXISTS oltp.tb_payment CASCADE;
DROP TABLE IF EXISTS oltp.tb_promotion CASCADE;
DROP TABLE IF EXISTS oltp.tb_product CASCADE;
DROP TABLE IF EXISTS oltp.tb_store CASCADE;
DROP TABLE IF EXISTS oltp.tb_channel CASCADE;
DROP TABLE IF EXISTS oltp.tb_customer CASCADE;

CREATE TABLE oltp.tb_customer (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(120) NOT NULL,
    gender VARCHAR(20),
    birth_date DATE,
    email VARCHAR(160),
    phone VARCHAR(30),
    loyalty_tier VARCHAR(30) NOT NULL,
    customer_segment VARCHAR(60),
    province VARCHAR(80),
    city VARCHAR(80),
    registered_date DATE
);

CREATE TABLE oltp.tb_channel (
    channel_id VARCHAR(20) PRIMARY KEY,
    channel_name VARCHAR(60) NOT NULL,
    channel_type VARCHAR(30) NOT NULL
);

CREATE TABLE oltp.tb_store (
    store_id VARCHAR(20) PRIMARY KEY,
    store_name VARCHAR(160) NOT NULL,
    store_type VARCHAR(60) NOT NULL,
    province VARCHAR(80) NOT NULL,
    city VARCHAR(80) NOT NULL,
    region VARCHAR(80) NOT NULL,
    open_date DATE
);

CREATE TABLE oltp.tb_product (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(160) NOT NULL,
    brand VARCHAR(60) NOT NULL,
    category VARCHAR(60) NOT NULL,
    subcategory VARCHAR(60),
    unit_price NUMERIC(14,2) NOT NULL,
    cost_price NUMERIC(14,2) NOT NULL,
    launch_date DATE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE oltp.tb_promotion (
    promotion_id VARCHAR(20) PRIMARY KEY,
    promotion_name VARCHAR(160) NOT NULL,
    promotion_type VARCHAR(60) DEFAULT 'No Promotion',
    discount_rate NUMERIC(6,4) NOT NULL DEFAULT 0,
    start_date DATE,
    end_date DATE
);

CREATE TABLE oltp.tb_payment (
    payment_id VARCHAR(20) PRIMARY KEY,
    payment_method VARCHAR(60) NOT NULL,
    payment_status VARCHAR(30) NOT NULL,
    payment_provider VARCHAR(80),
    paid_amount NUMERIC(14,2) NOT NULL DEFAULT 0
);

CREATE TABLE oltp.tb_sales_transaction (
    transaction_id VARCHAR(20) PRIMARY KEY,
    transaction_date TIMESTAMP NOT NULL,
    customer_id VARCHAR(20) NOT NULL REFERENCES oltp.tb_customer(customer_id),
    store_id VARCHAR(20) NOT NULL REFERENCES oltp.tb_store(store_id),
    channel_id VARCHAR(20) NOT NULL REFERENCES oltp.tb_channel(channel_id),
    payment_id VARCHAR(20) NOT NULL REFERENCES oltp.tb_payment(payment_id),
    salesperson_id VARCHAR(20)
);

CREATE TABLE oltp.tb_sales_detail (
    detail_id VARCHAR(20) PRIMARY KEY,
    transaction_id VARCHAR(20) NOT NULL REFERENCES oltp.tb_sales_transaction(transaction_id),
    product_id VARCHAR(20) NOT NULL REFERENCES oltp.tb_product(product_id),
    promotion_id VARCHAR(20) NOT NULL REFERENCES oltp.tb_promotion(promotion_id),
    quantity INTEGER NOT NULL,
    unit_price NUMERIC(14,2) NOT NULL,
    discount_amount NUMERIC(14,2) NOT NULL DEFAULT 0
);

CREATE TABLE oltp.tb_inventory (
    inventory_id VARCHAR(80) PRIMARY KEY,
    snapshot_date DATE NOT NULL,
    store_id VARCHAR(20) NOT NULL REFERENCES oltp.tb_store(store_id),
    product_id VARCHAR(20) NOT NULL REFERENCES oltp.tb_product(product_id),
    stock_quantity INTEGER NOT NULL,
    reorder_level INTEGER NOT NULL,
    stock_status VARCHAR(30) NOT NULL
);
