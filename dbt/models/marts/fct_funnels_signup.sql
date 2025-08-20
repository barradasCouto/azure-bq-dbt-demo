
{{ config(
    materialized='table',
    partition_by={'field': 'ts', 'data_type': 'timestamp'},
    cluster_by=['event_name']
) }}
with base as (
  select * from {{ ref('stg_events') }}
  where consent_measurement = true
)
, steps as (
  select
    customer_id, ts, event_name
  from base
  where event_name in ('page_view','add_to_cart','begin_checkout','purchase','signup')
)
select * from steps
