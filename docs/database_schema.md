# Database Schema

This project uses four PostgreSQL schemas:

1. `oltp` for normalized operational source tables.
2. `staging` for extracted source tables before transformation.
3. `dw` for the dimensional data warehouse with dimensions and facts.
4. `olap` for aggregate tables and dashboard-ready marts.


## OLTP Schema

The OLTP schema stores normalized operational data.

### Tables

| Table | Primary Key | Description |
|---|---|---|
| `oltp.tb_customer` | `customer_id` | Customer master data from CRM. |
| `oltp.tb_product` | `product_id` | Product master data. |
| `oltp.tb_store` | `store_id` | Store and location master data. |
| `oltp.tb_channel` | `channel_id` | Sales channel reference. |
| `oltp.tb_payment` | `payment_id` | Payment transaction data. |
| `oltp.tb_promotion` | `promotion_id` | Promotion campaign data. |
| `oltp.tb_sales_transaction` | `transaction_id` | Sales transaction header. |
| `oltp.tb_sales_detail` | `detail_id` | Sales line item detail. |
| `oltp.tb_inventory` | `inventory_id` | Product-store inventory snapshot. |

### OLTP Relationships

```text
tb_customer.customer_id
    -> tb_sales_transaction.customer_id

tb_store.store_id
    -> tb_sales_transaction.store_id
    -> tb_inventory.store_id

tb_channel.channel_id
    -> tb_sales_transaction.channel_id

tb_payment.payment_id
    -> tb_sales_transaction.payment_id

tb_sales_transaction.transaction_id
    -> tb_sales_detail.transaction_id

tb_product.product_id
    -> tb_sales_detail.product_id
    -> tb_inventory.product_id

tb_promotion.promotion_id
    -> tb_sales_detail.promotion_id
```

## Staging Schema

The staging schema mirrors the OLTP schema.

| Staging Table | Source Table |
|---|---|
| `staging.stg_customer` | `oltp.tb_customer` |
| `staging.stg_product` | `oltp.tb_product` |
| `staging.stg_store` | `oltp.tb_store` |
| `staging.stg_channel` | `oltp.tb_channel` |
| `staging.stg_payment` | `oltp.tb_payment` |
| `staging.stg_promotion` | `oltp.tb_promotion` |
| `staging.stg_sales_transaction` | `oltp.tb_sales_transaction` |
| `staging.stg_sales_detail` | `oltp.tb_sales_detail` |
| `staging.stg_inventory` | `oltp.tb_inventory` |

## Data Warehouse Schema

The `dw` schema contains the dimensional model.

### Dimension Tables

| Dimension Table | Surrogate Key | Business Key |
|---|---|---|
| `dw.dim_time` | `time_key` | `full_date` |
| `dw.dim_customer` | `customer_key` | `customer_id` |
| `dw.dim_product` | `product_key` | `product_id` |
| `dw.dim_store` | `store_key` | `store_id` |
| `dw.dim_channel` | `channel_key` | `channel_id` |
| `dw.dim_payment` | `payment_key` | `payment_id` |
| `dw.dim_promotion` | `promotion_key` | `promotion_id` |

### Fact Tables

| Fact Table | Grain |
|---|---|
| `dw.fact_sales` | One row per product item in one sales transaction. |
| `dw.fact_inventory_snapshot` | One row per product per store per snapshot date. |

### Star Schema: Sales

```text
                         dim_time
                            |
dim_customer --        fact_sales        -- dim_product
dim_store    --            |             -- dim_channel
dim_payment  --            |             -- dim_promotion
```

`dw.fact_sales` foreign keys:

| Column | References |
|---|---|
| `time_key` | `dw.dim_time.time_key` |
| `customer_key` | `dw.dim_customer.customer_key` |
| `product_key` | `dw.dim_product.product_key` |
| `store_key` | `dw.dim_store.store_key` |
| `channel_key` | `dw.dim_channel.channel_key` |
| `payment_key` | `dw.dim_payment.payment_key` |
| `promotion_key` | `dw.dim_promotion.promotion_key` |

### Star Schema: Inventory

```text
dim_time    --
dim_product -- fact_inventory_snapshot
dim_store   --
```

`dw.fact_inventory_snapshot` foreign keys:

| Column | References |
|---|---|
| `time_key` | `dw.dim_time.time_key` |
| `product_key` | `dw.dim_product.product_key` |
| `store_key` | `dw.dim_store.store_key` |

## OLAP Schema

The `olap` schema contains aggregate and mart tables for dashboard usage.

| OLAP Table | Description |
|---|---|
| `olap.agg_monthly_sales` | Monthly sales, profit, quantity, and transaction trend. |
| `olap.agg_sales_by_channel` | Omnichannel performance comparison. |
| `olap.agg_sales_by_region` | Regional sales and profit analysis. |
| `olap.agg_top_products` | Top product ranking by quantity, sales, and profit. |
| `olap.agg_inventory_stockout` | Low stock and stockout monitoring. |
| `olap.mart_sales_overview` | Wide table joining sales fact with main dimensions. |

## End-to-End Schema Flow

```text
data/raw/customers.csv
data/raw/products.csv
data/raw/stores.csv
data/raw/sales_transactions.csv
data/raw/sales_details.csv
data/raw/inventory.csv
data/raw/payments.csv
data/raw/promotions.csv
        |
        v
oltp.tb_customer
oltp.tb_product
oltp.tb_store
oltp.tb_channel
oltp.tb_payment
oltp.tb_promotion
oltp.tb_sales_transaction
oltp.tb_sales_detail
oltp.tb_inventory
        |
        v
staging.stg_*
        |
        v
dw.dim_time
dw.dim_customer
dw.dim_product
dw.dim_store
dw.dim_channel
dw.dim_payment
dw.dim_promotion
dw.fact_sales
dw.fact_inventory_snapshot
        |
        v
olap.agg_*
olap.mart_sales_overview
        |
        v
output/*.csv
```
