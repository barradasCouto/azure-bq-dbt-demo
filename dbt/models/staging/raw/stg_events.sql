
{{ config(materialized='view') }}
with src as (
  select
    event_id,
    cast(customer_id as int64) as customer_id,
    ts AS ts,
    event_name,
    page,
    region,
    cast(consent_measurement as bool) as consent_measurement,
    cast(consent_marketing as bool) as consent_marketing
  from {{ source('raw', 'events') }}
)
select *
from src
qualify row_number() over (partition by event_id order by ts desc) = 1
