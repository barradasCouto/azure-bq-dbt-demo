
# DataOps Runbook — Azure→BigQuery Demo

## SLOs/SLA
- Freshness SLO: **30 minutes** for `analytics` marts
- Success rate: **≥99.5%**
- Incident acknowledgement: **15 minutes** (business hours)

## Detection
- dbt source freshness checks (see `models/schema.yml`)
- Airbyte job alerts (failure notifications)
- Optional anomaly checks (Elementary/GE)

## Mitigation
1. Identify failing step (Airbyte sync vs dbt build)
2. For Airbyte failures: re-run last successful sync range; backfill window
3. For dbt failures: run affected model with `--select` and document root cause

## Rollback
- Tag last good dbt build: `dbt build --select state:modified --state target/`
- Re-point BI to last good `analytics` tables (or use versioned schemas)

## Parity & Validation
- Run `bigquery/parity_checks.sql` after cutover
- Acceptance: row counts within agreed threshold; checksum stable

## Cost Guardrails
- Partition by event timestamp; cluster by event/customer
- Table TTL on scratch tables
- Weekly review of `bigquery/cost_monitor.sql`

## Security & Privacy
- EU region for datasets
- Enforce consent filters in marts (`consent_measurement = TRUE`)
- PII avoided (hashed emails only), apply policy tags if needed
