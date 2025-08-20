
{{ config(
    materialized='table',
    partition_by={'field': 'ts', 'data_type': 'timestamp'},
    cluster_by=['event_name']
) }}
with base as (
  select * from {{ ref('stg_events') }}
  where consent_measurement = true
)
, marked as (
  select
    customer_id,
    ts,
    event_name,
    page,
    case
      when lag(ts) over (partition by customer_id order by ts) is null then 1
      when timestamp_diff(ts, lag(ts) over (partition by customer_id order by ts), minute) > 30 then 1
      else 0
    end as new_session_flag
  from base
)
, sessionized as (
  select
    customer_id,
    ts,
    event_name,
    page,
    sum(new_session_flag) over (partition by customer_id order by ts) as session_id
  from marked
)
select * from sessionized
