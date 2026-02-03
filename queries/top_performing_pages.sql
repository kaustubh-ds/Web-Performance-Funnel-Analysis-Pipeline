SELECT
  -- Extracting clean URL and Title from nested GA4 data structure
  (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'page_location') AS page_url,
  (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'page_title') AS page_title,
  COUNT(*) AS total_page_views,
  COUNT(DISTINCT user_pseudo_id) AS unique_visitors
FROM `cloud-project.analytics_NUMBER.events_*`
WHERE event_name = 'page_view'
  AND _TABLE_SUFFIX BETWEEN 
    FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL EXTRACT(DAYOFWEEK FROM CURRENT_DATE()) + 5 DAY)) 
    AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL EXTRACT(DAYOFWEEK FROM CURRENT_DATE()) - 1 DAY))
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 10
