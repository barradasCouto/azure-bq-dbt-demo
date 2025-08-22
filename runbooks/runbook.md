
# DataOps Runbook — Azure → BigQuery (EU) + dbt

**Stack:** Azure SQL / CSV → BigQuery (`raw`, `analytics`) → dbt (staging → marts)  
**Privacy invariant:** All marts gate on `consent_measurement = TRUE` (consent-first modeling).

## SLOs & SLIs
- Freshness (analytics marts): ≤ 30 min (P95)
- Build success: ≥ 99.5% (7-day)
- Cost: alert if billed bytes/day > 5 GB (demo threshold)

## Detection
- dbt tests (unique/not_null/accepted_values)
- Optional: dbt source freshness on raw.events.ts
- Weekly cost review via INFORMATION_SCHEMA.JOBS_BY_PROJECT (see docs/cost_last7d.txt)

## Mitigation
- Ingest fail → re-run window/backfill
- dbt fail → fix model or data contract; `dbt run --select <model+parents>`
- Recon parity (counts + checksum) must be ±0.5–1% before “green”

## Rollback
- Keep last-good tables; re-point exposure to previous version
- Documented in this runbook; recon snapshot proves safe state

## Cost guardrails
- Partition on ts; cluster by event_name (or customer_id)
- Prune by date; avoid SELECT *
- Dataset TTL for scratch; weekly jobs audit

## Privacy
- Consent enforced in marts: `consent_measurement = TRUE`
- EU-only datasets; avoid raw PII; hashed ids / policy tags (next step)
