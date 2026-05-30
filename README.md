# Erajaya Data Warehouse

## Group Profile

**Project:** `erajaya-data-warehouse`

| No | Name | Student ID |
|---:|---|---|
| 1 | Muhammad Zahran Muntazar | 140810230014 |
| 2 | Eusthachius Rivan Verianto Norel | 140810230016 |
| 3 | Gunawan Sabili Rohman | 140810230018 |

## Project Description

This repository contains a notebook-based data warehouse project for the case study:

**Data Warehouse Design for Device Sales Analysis and Omnichannel Strategy Optimization at Erajaya Group**

The project prepares a complete technical workflow for generating operational retail data, normalizing the design, loading an OLTP schema, extracting data into staging, transforming it into a dimensional data warehouse, running data quality checks, building OLAP aggregate tables, and exporting dashboard-ready CSV files.

The pipeline is executed through four smaller notebooks:

| Notebook | Purpose |
|---|---|
| [notebooks/01_extract_profile.ipynb](notebooks/01_extract_profile.ipynb) | Read existing raw operational CSV files and profile the source dataset. |
| [notebooks/02_transform_validate.ipynb](notebooks/02_transform_validate.ipynb) | Transform raw data into dimension/fact CSV files and run data quality checks. |
| [notebooks/03_load_postgres_olap.ipynb](notebooks/03_load_postgres_olap.ipynb) | Load OLTP, staging, data warehouse tables, build OLAP tables, and export dashboard CSVs. |
| [notebooks/04_etl_run_summary.ipynb](notebooks/04_etl_run_summary.ipynb) | Summarize raw, processed, output, and database row counts. |

## Dataset

The dataset is stored as raw operational CSV source files and follows a structured retail electronics scenario with OLTP tables, dimension tables, fact tables, and OLAP-ready aggregate outputs.

Current raw dataset scope includes 1,000 customer rows including `Guest Customer` and 100 curated product SKUs based on Erajaya/Eraspace catalog items.

Dataset details, source files, and table descriptions are available in:

[docs/dataset.md](docs/dataset.md)

Warehouse table definitions, columns, and relationships are available in:

[docs/data_dictionary.md](docs/data_dictionary.md)

The complete database schema flow is available in:

[docs/database_schema.md](docs/database_schema.md)

## Pipeline Architecture

```text
Jupyter Notebook
    -> Generate CSV Source Data
    -> PostgreSQL OLTP Schema
    -> PostgreSQL Staging Schema
    -> Dimensional Data Warehouse Schema
    -> Data Quality Checks
    -> OLAP Aggregate Tables
    -> Dashboard-ready CSV Exports
```

The represented source systems are:

- POS System for offline store transactions such as Erafone and iBox.
- E-Commerce Platform for Eraspace, online web, and marketplace channels.
- ERP System for product-store inventory snapshots.
- CRM System for customers, loyalty tiers, and customer segmentation.
- Payment System for payment method, provider, amount, and transaction status.
- Promotion System for discounts, campaigns, and bundling.

## Project Structure

```text
erajaya-data-warehouse/
|-- data/
|   |-- raw/                  # Raw operational CSV source data
|   |-- processed/            # Dimension and fact CSV files
|   `-- validation/           # ETL validation, rejected records, and run summaries
|-- docs/                     # Technical documentation
|-- notebooks/                # Step-by-step Jupyter Notebook pipeline
|-- output/                   # Dashboard-ready CSV outputs
|-- sql/                      # PostgreSQL schema files
|-- requirements.txt
`-- .env.example
```

## Why Jupyter Notebook?

This project is now notebook-first because the team wants easier control during execution, presentation, and debugging. The notebook allows the pipeline to be run section by section while still keeping SQL schema files, documentation, and output CSV files organized in separate folders.

Use the notebook for:

- Step-by-step execution during demonstration.
- Easier monitoring of source dataset sizes.
- Inspecting intermediate outputs.
- Running data quality checks visibly.
- Exporting dashboard-ready CSV files.

## Installation

```bash
cd erajaya-data-warehouse
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

For macOS/Linux:

```bash
source .venv/bin/activate
pip install -r requirements.txt
```

## Environment Configuration

Copy `.env.example` to `.env`.

Windows:

```bash
copy .env.example .env
```

macOS/Linux:

```bash
cp .env.example .env
```

Example:

```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=erajaya_dw
DB_USER=postgres
DB_PASSWORD=postgres
```

## PostgreSQL Database Setup

Create the target database before running the notebook:

```sql
CREATE DATABASE erajaya_dw;
```

The notebook executes the schema files automatically:

- `sql/01_oltp_schema.sql`
- `sql/02_staging_schema.sql`
- `sql/03_dw_schema.sql`
- `sql/04_olap_schema.sql`

## How to Run the Project

Use the notebook order below to run the pipeline from source profiling to warehouse outputs.

Start Jupyter Notebook:

```bash
python -m notebook
```

Open and run these notebooks in order:

```text
notebooks/01_extract_profile.ipynb
notebooks/02_transform_validate.ipynb
notebooks/03_load_postgres_olap.ipynb
notebooks/04_etl_run_summary.ipynb
```

Run all cells from top to bottom inside each notebook before moving to the next one.

The notebooks perform:

```text
extract/profile -> transform/validate -> load PostgreSQL/build OLAP -> summarize
```

## Dashboard-ready Outputs

| Output File | Description |
|---|---|
| `output/dq_summary.csv` | Data quality check results. |
| `output/agg_monthly_sales.csv` | Monthly sales, profit, quantity, and transaction trend. |
| `output/agg_sales_by_channel.csv` | Sales and profit comparison by omnichannel channel. |
| `output/agg_sales_by_region.csv` | Sales and profit by province and city. |
| `output/agg_top_products.csv` | Top products by quantity, sales, and profit. |
| `output/agg_inventory_stockout.csv` | Low stock and stockout product-store records. |
| `output/mart_sales_overview.csv` | Wide analytical table joining sales facts with main dimensions. |

## Validation Outputs

Validation artifacts are stored in:

```text
data/validation/
```

Key files:

| Validation File | Description |
|---|---|
| `extract_profile_summary.csv` | Raw source profile summary. |
| `transform_table_validation.csv` | Row, column, and key validation for dim/fact tables. |
| `transform_numeric_validation.csv` | Numeric validation for sales and inventory fields. |
| `transform_fk_validation.csv` | Fact-to-dimension foreign key validation. |
| `etl_summary_rejected_records.csv` | Summary of rejected records. |
| `etl_summary_processed_tables.csv` | Summary of raw, processed, output, and validation CSV files. |
| `etl_summary_overall_status.csv` | Overall ETL validation status. |
| `load_results.csv` | PostgreSQL load result per table, created after Notebook 03 runs successfully. |
| `load_column_validation.csv` | PostgreSQL column validation, created after Notebook 03 runs successfully. |
| `load_final_counts.csv` | Final PostgreSQL row counts, created after Notebook 03 runs successfully. |


## Course Feedback Coverage

This project addresses the expected feedback for a stronger data warehouse submission:

- It demonstrates data normalization from UNF to 3NF.
- It uses a complete retail operational design with customers, products, stores, channels, payments, promotions, sales details, and inventory.
- It continues beyond ETL into data quality checks, OLAP aggregates, and dashboard-ready outputs.
- It provides documentation that can be referenced directly in the final paper.

## Main Documentation

| Document | Purpose |
|---|---|
| [docs/dataset.md](docs/dataset.md) | Describes source data files and dataset scope. |
| [docs/data_dictionary.md](docs/data_dictionary.md) | Describes table columns and relationships. |
| [docs/database_schema.md](docs/database_schema.md) | Explains OLTP, staging, DW, and OLAP database schemas. |
