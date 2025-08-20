
# Azure → BigQuery + dbt Starter (v2)

This is a compact, interview-ready demo showing:
- Azure SQL (or local SQL Server) → Airbyte → BigQuery (EU) → dbt (staging + marts)
- Consent-aware modeling (`consent_measurement`, `consent_marketing`)
- Parity checks, basic SLOs, and cost guardrails

## Quick Steps
1) **Create source DB**
   - Run `sql/schema.sql` in Azure SQL or local SQL Server
   - Import CSVs in `data/` into the 3 tables (`customers`, `orders`, `events`)
2) **BigQuery**
   ```bash
   bq --location=EU mk --dataset <PROJECT_ID>:raw
   bq --location=EU mk --dataset <PROJECT_ID>:analytics
   ```
3) **Airbyte**
   - Source: MSSQL (host/user/pw/DB you created)
   - Destination: BigQuery (EU) with a service account key
   - Sync tables to dataset `raw`
4) **dbt (BigQuery)**
   - Put `dbt_project/` in a repo; create a profile named `usercentrics_demo`
   - `dbt deps && dbt run && dbt test && dbt docs generate`
5) **Parity & cost**
   - Run the SQL in `bigquery/parity_checks.sql` and `bigquery/cost_monitor.sql`
6) **Runbook**
   - See `runbooks/runbook.md` for SLOs, rollback, and incident SOP

> Tip: Partition & cluster marts to keep costs predictable.
