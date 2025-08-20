
-- BigQuery cost/usage monitor (EU)
SELECT DATE(creation_time) AS day,
       user_email,
       SUM(total_bytes_billed)/1e9 AS gb_billed,
       COUNTIF(statement_type='SELECT') AS selects,
       COUNTIF(statement_type='INSERT') AS inserts,
       COUNTIF(statement_type='MERGE')  AS merges
FROM `region-eu`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
WHERE DATE(creation_time) >= DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
GROUP BY 1,2
ORDER BY 1 DESC;
