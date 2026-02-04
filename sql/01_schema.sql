-- Order-to-Cash Intelligence Assistant – Azure SQL schema
-- Run this script in Azure SQL DB (or SQL Server) to create the base tables.
-- Order: customers → orders → order_line_items → invoices → payments

-- ---------------------------------------------------------------------------
-- 1. customers
-- ---------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'customers')
CREATE TABLE dbo.customers (
    id              INT IDENTITY(1,1) NOT NULL,
    customer_code   NVARCHAR(32)      NOT NULL,
    name            NVARCHAR(256)    NOT NULL,
    payment_terms   NVARCHAR(32)     NULL,           -- e.g. NET30, NET60
    credit_limit    DECIMAL(18,2)    NULL,
    created_at      DATETIME2(3)     NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at      DATETIME2(3)     NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_customers PRIMARY KEY (id),
    CONSTRAINT UQ_customers_code UNIQUE (customer_code)
);

-- ---------------------------------------------------------------------------
-- 2. orders
-- ---------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'orders')
CREATE TABLE dbo.orders (
    id              INT IDENTITY(1,1) NOT NULL,
    customer_id     INT               NOT NULL,
    order_number    NVARCHAR(32)      NOT NULL,
    order_date      DATE              NOT NULL,
    status          NVARCHAR(32)     NOT NULL,      -- PENDING_APPROVAL, APPROVED, SHIPPED, CANCELLED
    total_amount    DECIMAL(18,2)    NOT NULL,
    created_at      DATETIME2(3)      NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at      DATETIME2(3)      NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_orders PRIMARY KEY (id),
    CONSTRAINT UQ_orders_number UNIQUE (order_number),
    CONSTRAINT FK_orders_customer FOREIGN KEY (customer_id) REFERENCES dbo.customers(id)
);

-- ---------------------------------------------------------------------------
-- 3. order_line_items
-- ---------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'order_line_items')
CREATE TABLE dbo.order_line_items (
    id              INT IDENTITY(1,1) NOT NULL,
    order_id        INT               NOT NULL,
    product_sku     NVARCHAR(64)      NOT NULL,
    product_name    NVARCHAR(256)     NULL,
    quantity        DECIMAL(18,4)     NOT NULL,
    unit_price      DECIMAL(18,4)     NOT NULL,
    line_total      DECIMAL(18,2)     NOT NULL,
    created_at      DATETIME2(3)      NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_order_line_items PRIMARY KEY (id),
    CONSTRAINT FK_order_line_items_order FOREIGN KEY (order_id) REFERENCES dbo.orders(id)
);

-- ---------------------------------------------------------------------------
-- 4. invoices
-- ---------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'invoices')
CREATE TABLE dbo.invoices (
    id              INT IDENTITY(1,1) NOT NULL,
    order_id        INT               NULL,          -- nullable if invoice is for multiple orders / adjustments
    customer_id     INT               NOT NULL,
    invoice_number NVARCHAR(32)      NOT NULL,
    invoice_date    DATE              NOT NULL,
    due_date       DATE              NOT NULL,
    amount         DECIMAL(18,2)     NOT NULL,
    status         NVARCHAR(32)     NOT NULL,      -- PENDING, PAID, OVERDUE, DISPUTED, CANCELLED
    notes          NVARCHAR(MAX)     NULL,          -- e.g. dispute reason, payment terms summary
    created_at      DATETIME2(3)      NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at      DATETIME2(3)      NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_invoices PRIMARY KEY (id),
    CONSTRAINT UQ_invoices_number UNIQUE (invoice_number),
    CONSTRAINT FK_invoices_order FOREIGN KEY (order_id) REFERENCES dbo.orders(id),
    CONSTRAINT FK_invoices_customer FOREIGN KEY (customer_id) REFERENCES dbo.customers(id)
);

-- ---------------------------------------------------------------------------
-- 5. payments
-- ---------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'payments')
CREATE TABLE dbo.payments (
    id              INT IDENTITY(1,1) NOT NULL,
    invoice_id      INT               NOT NULL,
    payment_date    DATE              NOT NULL,
    amount          DECIMAL(18,2)     NOT NULL,
    payment_method  NVARCHAR(32)     NULL,          -- WIRE, CHECK, CARD, etc.
    reference       NVARCHAR(128)    NULL,          -- check number, transaction id
    created_at      DATETIME2(3)      NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_payments PRIMARY KEY (id),
    CONSTRAINT FK_payments_invoice FOREIGN KEY (invoice_id) REFERENCES dbo.invoices(id)
);

-- ---------------------------------------------------------------------------
-- Indexes for common query patterns (orders pending, invoices overdue, etc.)
-- ---------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_orders_customer_status' AND object_id = OBJECT_ID('dbo.orders'))
    CREATE INDEX IX_orders_customer_status ON dbo.orders (customer_id, status);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_orders_order_date' AND object_id = OBJECT_ID('dbo.orders'))
    CREATE INDEX IX_orders_order_date ON dbo.orders (order_date);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_invoices_customer_status' AND object_id = OBJECT_ID('dbo.invoices'))
    CREATE INDEX IX_invoices_customer_status ON dbo.invoices (customer_id, status);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_invoices_due_date' AND object_id = OBJECT_ID('dbo.invoices'))
    CREATE INDEX IX_invoices_due_date ON dbo.invoices (due_date);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_payments_invoice' AND object_id = OBJECT_ID('dbo.payments'))
    CREATE INDEX IX_payments_invoice ON dbo.payments (invoice_id);
