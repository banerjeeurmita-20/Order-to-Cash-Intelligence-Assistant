# Step 2: Data model (Azure SQL DDL)

## What we added

- **`sql/01_schema.sql`** – DDL for the Order-to-Cash schema. Creates five tables in dependency order and adds indexes for common query patterns.

## Tables

| Table              | Purpose |
|--------------------|---------|
| **customers**      | Customer master: code, name, payment terms (e.g. NET30), credit limit. |
| **orders**         | Sales orders: customer, order number, date, status (PENDING_APPROVAL, APPROVED, SHIPPED, CANCELLED), total amount. |
| **order_line_items** | Line-level detail: order, product SKU/name, quantity, unit price, line total. |
| **invoices**       | Invoices: link to order (optional) and customer, number, dates, amount, status (PENDING, PAID, OVERDUE, DISPUTED), notes (e.g. dispute reason). |
| **payments**       | Payments against invoices: invoice, payment date, amount, method, reference. |

## Relationships

```
customers 1 ─── * orders
orders    1 ─── * order_line_items
orders    1 ─── * invoices  (optional; invoice can reference one order)
customers 1 ─── * invoices
invoices  1 ─── * payments
```

## How to run

1. Create an **Azure SQL Database** (or use SQL Server locally).
2. Connect with **Azure Data Studio**, **SSMS**, or **sqlcmd**.
3. Execute **`sql/01_schema.sql`** against the target database.

   The script uses `IF NOT EXISTS` so it is safe to run more than once; it will not drop or overwrite existing tables.

## Query patterns supported (for RAG / app later)

- **Orders pending approval:** `SELECT * FROM orders WHERE status = 'PENDING_APPROVAL'`
- **Invoices overdue:** `SELECT * FROM invoices WHERE status IN ('PENDING','OVERDUE') AND due_date < GETDATE()`
- **Payment terms by customer:** `SELECT c.name, c.payment_terms FROM customers c WHERE c.id = @customer_id`
- **Why was invoice disputed:** `SELECT notes FROM invoices WHERE id = @id AND status = 'DISPUTED'`

Next: **Step 3 – Sample / mock data** (CSV or scripts to populate these tables for local/dev and ADF testing).
