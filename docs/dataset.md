# Dataset

## Overview

The raw dataset is stored as fixed operational CSV source data for a retail electronics data warehouse case study based on Erajaya Group's omnichannel business context. It is designed to represent multiple operational source systems and to support normalization, ETL, dimensional modeling, data quality validation, OLAP aggregation, and dashboard development.

The raw source dataset is stored in:

```text
data/raw/
```

The raw dataset is not stored directly as dimension and fact tables because it represents operational source systems. Dimension and fact tables are produced later in the `dw` schema after the notebook performs extraction, transformation, surrogate key generation, and metric calculation.

## Source System Representation

| Source System | Dataset Representation |
|---|---|
| POS System | Offline store sales transactions from stores such as iBox, Erafone, and Urban Republic. |
| E-Commerce Platform | Online Web and Marketplace transactions representing Eraspace-style channels. |
| ERP System | Inventory snapshot per product-store combination. |
| CRM System | Customer profile, loyalty tier, customer segment, and registration data. |
| Payment System | Payment method, payment status, provider, and paid amount. |
| Promotion System | Campaign, discount, cashback, bundling, and loyalty reward data. |

## Raw Source Files

| File | Approx. Rows | Description |
|---|---:|---|
| `customers.csv` | 1,000 | Customer master data including one `Guest Customer` record. |
| `products.csv` | 100 | Curated product master data using real Erajaya/Eraspace catalog items and categories. |
| `stores.csv` | 25 | Store master data including store type, city, province, and region. |
| `sales_transactions.csv` | 2,000 | Sales transaction header data. |
| `sales_details.csv` | 4,000-6,000 | Line-item sales details; one row per product in a transaction. |
| `inventory.csv` | 2,500 | Product-store inventory snapshot rows. |
| `payments.csv` | 2,000 | Payment method, provider, status, and paid amount per transaction. |
| `promotions.csv` | 21 | Promotion campaigns including `No Promotion`. |

## Business Values Used

| Attribute | Values |
|---|---|
| Brand | Apple, Samsung, Xiaomi, OPPO, vivo, ASUS, JBL, Anker, Logitech |
| Category | Smartphone, Tablet, Laptop, Accessories, Wearable, Audio, Smart Home |
| Store Type | iBox, Erafone, Urban Republic, Eraspace |
| Channel | Offline Store, Online Web, Marketplace |
| Payment Method | Cash, Debit Card, Credit Card, QRIS, Bank Transfer, E-Wallet |
| Loyalty Tier | Regular, Silver, Gold, Platinum |

## Generated Metrics

Product names are curated from official Erajaya/Eraspace catalog references, so the product master does not use randomly invented product names.

The ETL process calculates:

| Metric | Formula |
|---|---|
| `gross_sales` | `quantity_sold * unit_price` |
| `net_sales` | `gross_sales - discount_amount` |
| `cost_amount` | `quantity_sold * cost_price` |
| `net_profit` | `net_sales - cost_amount` |

## Dataset Grain

| Dataset/Table | Grain |
|---|---|
| `sales_transactions.csv` | One row per sales transaction. |
| `sales_details.csv` | One row per product item in a transaction. |
| `inventory.csv` | One row per product per store per snapshot date. |
| `fact_sales` | One row per product item in a transaction. |
| `fact_inventory_snapshot` | One row per product per store per snapshot date. |

## Data Validation

Dataset validation is performed in:

```text
notebooks/02_transform_validate.ipynb
```

The validation step checks whether the raw source data and transformed warehouse data are consistent enough to be loaded into PostgreSQL and used for dashboard analysis.

| Validation Check | Purpose |
|---|---|
| Duplicate `transaction_id` | Ensures every sales transaction header is unique. |
| Duplicate `detail_id` | Ensures every sales line item is unique. |
| Quantity must be greater than 0 | Prevents invalid sales quantities. |
| Unit price must not be negative | Prevents invalid product selling prices. |
| Gross sales formula | Validates `gross_sales = quantity_sold * unit_price`. |
| Net sales must not be negative | Ensures discount does not exceed gross sales. |
| Product mapping to `dim_product` | Ensures every sales fact has a valid product dimension. |
| Guest customer handling | Ensures missing customers are mapped to `CUST-GUEST`. |
| Stock quantity must not be negative | Prevents invalid inventory values. |
| Source-to-fact net sales reconciliation | Compares source net sales with `fact_sales.net_sales`. |
| Valid payment status | Ensures payment status only uses `Paid`, `Pending`, `Failed`, or `Refunded`. |

Validation results are exported to:

```text
output/dq_summary.csv
data/validation/
```

Main validation files:

| File | Description |
|---|---|
| `extract_profile_summary.csv` | Source file profiling from Notebook 01. |
| `transform_table_validation.csv` | Dimension/fact table structure and key checks. |
| `transform_numeric_validation.csv` | Numeric rule checks for sales and inventory. |
| `transform_fk_validation.csv` | Foreign key checks from facts to dimensions. |
| `etl_summary_rejected_records.csv` | Rejected record summary. |
| `rejected_fact_sales_duplicate_detail.csv` | Duplicate sales detail records if found. |
| `rejected_fact_sales_fk.csv` | Fact rows with invalid dimension mapping if found. |
| `load_results.csv` | PostgreSQL table load status from Notebook 03. |
| `load_column_validation.csv` | PostgreSQL column validation from Notebook 03. |
| `load_final_counts.csv` | PostgreSQL final row counts from Notebook 03. |
| `etl_summary_overall_status.csv` | Overall validation status from Notebook 04. |

## Dashboard Use

The dashboard team should primarily use files in:

```text
output/
```

Recommended files:

- `mart_sales_overview.csv` for flexible filtering and exploration.
- `agg_monthly_sales.csv` for sales trends.
- `agg_sales_by_channel.csv` for omnichannel comparison.
- `agg_sales_by_region.csv` for regional performance.
- `agg_top_products.csv` for product ranking.
- `agg_inventory_stockout.csv` for inventory risk analysis.

## Processed Dimension and Fact Files

After running `notebooks/02_transform_validate.ipynb`, the project also produces data warehouse-shaped CSV files in:

```text
data/processed/
```

These files are easier to inspect before loading into PostgreSQL:

- `dim_time.csv`
- `dim_customer.csv`
- `dim_product.csv`
- `dim_store.csv`
- `dim_channel.csv`
- `dim_payment.csv`
- `dim_promotion.csv`
- `fact_sales.csv`
- `fact_inventory_snapshot.csv`
