# Data Dictionary

## OLTP Schema

### `oltp.tb_customer`

| Column | Description |
|---|---|
| `customer_id` | Natural customer identifier. |
| `customer_name` | Customer full name. |
| `gender` | Customer gender. |
| `birth_date` | Customer birth date. |
| `email` | Customer email address. |
| `phone` | Customer phone number. |
| `loyalty_tier` | Loyalty tier: Regular, Silver, Gold, or Platinum. |
| `customer_segment` | Customer segment such as Student, Professional, Family, SMB. |
| `province` | Customer province. |
| `city` | Customer city. |
| `registered_date` | CRM registration date. |

### `oltp.tb_product`

| Column | Description |
|---|---|
| `product_id` | Natural product identifier. |
| `product_name` | Product display name. |
| `brand` | Product brand. |
| `category` | Product category. |
| `subcategory` | Product subcategory. |
| `unit_price` | Standard selling price. |
| `cost_price` | Product cost price used for profit calculation. |
| `launch_date` | Product launch date. |
| `is_active` | Product active flag. |

### `oltp.tb_store`

| Column | Description |
|---|---|
| `store_id` | Natural store identifier. |
| `store_name` | Store name. |
| `store_type` | Store type such as iBox, Erafone, Urban Republic, or Eraspace. |
| `province` | Store province. |
| `city` | Store city. |
| `region` | Regional grouping. |
| `open_date` | Store opening date. |

### `oltp.tb_channel`

| Column | Description |
|---|---|
| `channel_id` | Natural channel identifier. |
| `channel_name` | Channel name: Offline Store, Online Web, or Marketplace. |
| `channel_type` | Channel type: Offline or Online. |

### `oltp.tb_payment`

| Column | Description |
|---|---|
| `payment_id` | Natural payment identifier. |
| `payment_method` | Payment method. |
| `payment_status` | Payment status: Paid, Pending, Failed, or Refunded. |
| `payment_provider` | Bank, e-wallet, card network, or POS provider. |
| `paid_amount` | Total paid amount. |

### `oltp.tb_promotion`

| Column | Description |
|---|---|
| `promotion_id` | Natural promotion identifier. |
| `promotion_name` | Promotion campaign name. |
| `promotion_type` | Promotion type such as Cashback, Bundling, or Bank Discount. |
| `discount_rate` | Discount rate applied to eligible line items. |
| `start_date` | Promotion start date. |
| `end_date` | Promotion end date. |

### `oltp.tb_sales_transaction`

| Column | Description |
|---|---|
| `transaction_id` | Natural sales transaction identifier. |
| `transaction_date` | Transaction timestamp. |
| `customer_id` | FK to `tb_customer`. |
| `store_id` | FK to `tb_store`. |
| `channel_id` | FK to `tb_channel`. |
| `payment_id` | FK to `tb_payment`. |
| `salesperson_id` | Salesperson identifier for offline transactions. |

### `oltp.tb_sales_detail`

| Column | Description |
|---|---|
| `detail_id` | Natural line-item identifier. |
| `transaction_id` | FK to `tb_sales_transaction`. |
| `product_id` | FK to `tb_product`. |
| `promotion_id` | FK to `tb_promotion`. |
| `quantity` | Quantity sold. |
| `unit_price` | Selling price at transaction time. |
| `discount_amount` | Discount amount for the line item. |

### `oltp.tb_inventory`

| Column | Description |
|---|---|
| `inventory_id` | Natural inventory snapshot identifier. |
| `snapshot_date` | Inventory snapshot date. |
| `store_id` | FK to `tb_store`. |
| `product_id` | FK to `tb_product`. |
| `stock_quantity` | Available stock quantity. |
| `reorder_level` | Minimum stock threshold. |
| `stock_status` | Available, Low Stock, or Stockout. |

## Data Warehouse Schema

### Dimensions

| Dimension | Business Key | Surrogate Key | Description |
|---|---|---|---|
| `dw.dim_time` | `full_date` | `time_key` | Calendar dimension with year, quarter, month, day, and weekend flag. |
| `dw.dim_customer` | `customer_id` | `customer_key` | Customer attributes for loyalty and segmentation analysis. |
| `dw.dim_product` | `product_id` | `product_key` | Product, brand, category, price, and cost attributes. |
| `dw.dim_store` | `store_id` | `store_key` | Store and location attributes. |
| `dw.dim_channel` | `channel_id` | `channel_key` | Omnichannel attributes. |
| `dw.dim_payment` | `payment_id` | `payment_key` | Payment method, status, and provider attributes. |
| `dw.dim_promotion` | `promotion_id` | `promotion_key` | Promotion campaign attributes. |

### `dw.fact_sales`

Grain: one row per product item in a transaction.

| Column | Description |
|---|---|
| `sales_key` | Surrogate fact key. |
| `transaction_id` | Natural transaction identifier. |
| `detail_id` | Natural line-item identifier. |
| `time_key` | FK to `dim_time`. |
| `customer_key` | FK to `dim_customer`. |
| `product_key` | FK to `dim_product`. |
| `store_key` | FK to `dim_store`. |
| `channel_key` | FK to `dim_channel`. |
| `payment_key` | FK to `dim_payment`. |
| `promotion_key` | FK to `dim_promotion`. |
| `quantity_sold` | Quantity sold. |
| `unit_price` | Unit selling price. |
| `gross_sales` | Quantity multiplied by unit price. |
| `discount_amount` | Discount amount. |
| `net_sales` | Gross sales minus discount. |
| `cost_amount` | Quantity multiplied by cost price. |
| `net_profit` | Net sales minus cost amount. |

### `dw.fact_inventory_snapshot`

Grain: one row per product per store per snapshot date.

| Column | Description |
|---|---|
| `inventory_key` | Surrogate fact key. |
| `time_key` | FK to `dim_time`. |
| `product_key` | FK to `dim_product`. |
| `store_key` | FK to `dim_store`. |
| `stock_quantity` | Available stock quantity. |
| `reorder_level` | Minimum stock threshold. |
| `stock_status` | Available, Low Stock, or Stockout. |

## OLAP Tables

| Table | Purpose |
|---|---|
| `olap.agg_monthly_sales` | Monthly trend analysis. |
| `olap.agg_sales_by_channel` | Omnichannel performance comparison. |
| `olap.agg_sales_by_region` | Regional sales and profit analysis. |
| `olap.agg_top_products` | Product ranking analysis. |
| `olap.agg_inventory_stockout` | Inventory risk and stockout monitoring. |
| `olap.mart_sales_overview` | Wide dashboard mart combining fact sales and dimensions. |
