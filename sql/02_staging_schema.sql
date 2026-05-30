CREATE SCHEMA IF NOT EXISTS staging;

DROP TABLE IF EXISTS staging.stg_inventory CASCADE;
DROP TABLE IF EXISTS staging.stg_sales_detail CASCADE;
DROP TABLE IF EXISTS staging.stg_sales_transaction CASCADE;
DROP TABLE IF EXISTS staging.stg_payment CASCADE;
DROP TABLE IF EXISTS staging.stg_promotion CASCADE;
DROP TABLE IF EXISTS staging.stg_product CASCADE;
DROP TABLE IF EXISTS staging.stg_store CASCADE;
DROP TABLE IF EXISTS staging.stg_channel CASCADE;
DROP TABLE IF EXISTS staging.stg_customer CASCADE;

CREATE TABLE staging.stg_customer (LIKE oltp.tb_customer INCLUDING DEFAULTS);
CREATE TABLE staging.stg_channel (LIKE oltp.tb_channel INCLUDING DEFAULTS);
CREATE TABLE staging.stg_store (LIKE oltp.tb_store INCLUDING DEFAULTS);
CREATE TABLE staging.stg_product (LIKE oltp.tb_product INCLUDING DEFAULTS);
CREATE TABLE staging.stg_promotion (LIKE oltp.tb_promotion INCLUDING DEFAULTS);
CREATE TABLE staging.stg_payment (LIKE oltp.tb_payment INCLUDING DEFAULTS);
CREATE TABLE staging.stg_sales_transaction (LIKE oltp.tb_sales_transaction INCLUDING DEFAULTS);
CREATE TABLE staging.stg_sales_detail (LIKE oltp.tb_sales_detail INCLUDING DEFAULTS);
CREATE TABLE staging.stg_inventory (LIKE oltp.tb_inventory INCLUDING DEFAULTS);
