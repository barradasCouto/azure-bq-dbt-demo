
-- Parity / reconciliation checks

-- Row counts
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM `raw.customers`
UNION ALL SELECT 'orders', COUNT(*) FROM `raw.orders`
UNION ALL SELECT 'events', COUNT(*) FROM `raw.events`;

-- Sample checksum for orders
SELECT FARM_FINGERPRINT(STRING_AGG(CAST(order_id AS STRING)||CAST(amount AS STRING), ',' ORDER BY order_id)) AS checksum
FROM `raw.orders`;

-- Freshness (events)
SELECT MAX(ts) AS max_ts FROM `raw.events`;
