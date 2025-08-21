
{{ config(
    materialized='table',
    partition_by={'field': 'ts', 'data_type': 'timestamp'},
    cluster_by=['event_name']
) }}

WITH base AS (
  SELECT *
  FROM {{ ref('stg_events') }}
  WHERE consent_measurement = TRUE
),
steps AS (
  SELECT
    customer_id,
    ts,
    event_name,
    consent_measurement           -- <-- add this
  FROM base
  WHERE event_name IN ('page_view','add_to_cart','begin_checkout','purchase','signup')
)
SELECT
  customer_id,
  ts,
  event_name,
  consent_measurement             -- <-- keep it in the final select
FROM steps

