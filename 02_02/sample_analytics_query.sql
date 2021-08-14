#standardSQL
SELECT
date,
COUNT (DISTINCT visitId) as num_records,
SUM(totals.visits) as num_visits,
SUM(totals.hits) num_hits,
AVG(totals.pageviews) average_page_views,
AVG(totals.transactions) average_transactions,
SUM(totals.totalTransactionRevenue) total_revenue
FROM `bigquery-public-data.google_analytics_sample.ga_sessions*`
GROUP BY date
ORDER BY date
