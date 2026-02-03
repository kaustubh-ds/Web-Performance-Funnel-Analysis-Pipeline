WITH weekly_events AS (
  SELECT
    user_pseudo_id,
    event_name,
    PARSE_DATE('%Y%m%d', event_date) AS event_dt
  FROM `cloud-project.analytics_NUMBER.events_*`
  WHERE _TABLE_SUFFIX BETWEEN 
    -- Dynamic Date Logic: Automatically finds last Monday and last Sunday
    FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL EXTRACT(DAYOFWEEK FROM CURRENT_DATE()) + 5 DAY)) 
    AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL EXTRACT(DAYOFWEEK FROM CURRENT_DATE()) - 1 DAY))
),
funnel_counts AS (
  -- Aggregating unique users per stage
  SELECT
    COUNT(DISTINCT CASE WHEN event_name = 'session_start' THEN user_pseudo_id END) AS sessions,
    COUNT(DISTINCT CASE WHEN event_name = 'view_item' THEN user_pseudo_id END) AS product_views,
    COUNT(DISTINCT CASE WHEN event_name = 'add_to_cart' THEN user_pseudo_id END) AS add_to_carts,
    COUNT(DISTINCT CASE WHEN event_name = 'begin_checkout' THEN user_pseudo_id END) AS checkouts,
    COUNT(DISTINCT CASE WHEN event_name = 'purchase' THEN user_pseudo_id END) AS purchases
  FROM weekly_events
)
-- Final Output: displaying counts and calculating drop-off percentages
SELECT
  '1. Session Start' AS step, sessions AS users, 100.0 AS pct_of_total, NULL AS pct_drop_off FROM funnel_counts
UNION ALL
SELECT
  '2. Product View', product_views, ROUND(product_views * 100.0 / sessions, 2), ROUND((sessions - product_views) * 100.0 / sessions, 2) FROM funnel_counts
UNION ALL
SELECT
  '3. Add to Cart', add_to_carts, ROUND(add_to_carts * 100.0 / sessions, 2), ROUND((product_views - add_to_carts) * 100.0 / product_views, 2) FROM funnel_counts
UNION ALL
SELECT
  '4. Begin Checkout', checkouts, ROUND(checkouts * 100.0 / sessions, 2), ROUND((add_to_carts - checkouts) * 100.0 / add_to_carts, 2) FROM funnel_counts
UNION ALL
SELECT
  '5. Purchase', purchases, ROUND(purchases * 100.0 / sessions, 2), ROUND((checkouts - purchases) * 100.0 / checkouts, 2) FROM funnel_counts
ORDER BY step
