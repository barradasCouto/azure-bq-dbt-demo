{{ config(
    materialized='table',
    partition_by={'field': 'ts', 'data_type': 'timestamp'},
    cluster_by=['event_name']
) }}

WITH base AS (
  SELECT
    customer_id,
    SAFE_CAST(ts AS TIMESTAMP) AS ts,
    event_name,
    page
  FROM {{ ref('stg_events') }}
  WHERE consent_measurement = TRUE
),
ordered AS (
  SELECT
    customer_id,
    ts,
    event_name,
    page,
    LAG(ts) OVER (PARTITION BY customer_id ORDER BY ts) AS prev_ts
  FROM base
),
session_breaks AS (
  SELECT
    customer_id,
    ts,
    event_name,
    page,
    CASE
      WHEN prev_ts IS NULL THEN 1
      WHEN UNIX_SECONDS(ts) - UNIX_SECONDS(prev_ts) > 30 * 60 THEN 1
      ELSE 0
    END AS new_session_flag
  FROM ordered
)
SELECT
  customer_id,
  ts,
  event_name,
  page,
  SUM(new_session_flag) OVER (PARTITION BY customer_id ORDER BY ts) AS session_id
FROM session_breaks
