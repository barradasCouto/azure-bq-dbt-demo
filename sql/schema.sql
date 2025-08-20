
-- Azure SQL / SQL Server schema
CREATE TABLE dbo.customers (
  customer_id INT PRIMARY KEY,
  email_hash NVARCHAR(64) NOT NULL,
  region NVARCHAR(8) NOT NULL,
  created_at DATETIME2 NOT NULL,
  consent_measurement BIT NOT NULL,
  consent_marketing BIT NOT NULL
);

CREATE TABLE dbo.orders (
  order_id INT PRIMARY KEY,
  customer_id INT NOT NULL,
  order_ts DATETIME2 NOT NULL,
  status NVARCHAR(20) NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  updated_at DATETIME2 NOT NULL,
  CONSTRAINT FK_orders_customers FOREIGN KEY (customer_id) REFERENCES dbo.customers(customer_id)
);

CREATE TABLE dbo.events (
  event_id NVARCHAR(24) PRIMARY KEY,
  customer_id INT NOT NULL,
  ts DATETIME2 NOT NULL,
  event_name NVARCHAR(32) NOT NULL,
  page NVARCHAR(128) NULL,
  region NVARCHAR(8) NOT NULL,
  consent_measurement BIT NOT NULL,
  consent_marketing BIT NOT NULL,
  CONSTRAINT FK_events_customers FOREIGN KEY (customer_id) REFERENCES dbo.customers(customer_id)
);
