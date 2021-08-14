SELECT geoNetwork.region, 
SUM(totals.totalTransactionRevenue) as Total_Revenue
FROM
`bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
WHERE geoNetwork.region IS NOT NULL
GROUP BY geoNetwork.region
ORDER BY Total_Revenue DESC
