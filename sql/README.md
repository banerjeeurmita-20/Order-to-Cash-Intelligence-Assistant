# SQL (Azure SQL DB)

DDL scripts and migrations for the Order-to-Cash schema.

## Files

| File | Description |
|------|-------------|
| **01_schema.sql** | Creates tables: `customers`, `orders`, `order_line_items`, `invoices`, `payments`, plus indexes. Safe to run multiple times (IF NOT EXISTS). |

## How to run

Execute `01_schema.sql` in Azure SQL Database (or SQL Server) using Azure Data Studio, SSMS, or sqlcmd. See **docs/STEP2-DATA-MODEL.md** for table descriptions and relationships.
