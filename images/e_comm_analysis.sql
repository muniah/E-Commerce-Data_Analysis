-- E-Commerce Data Analysis
-- 1. Traffic and source Analysis: 

-- Session count per source:
SELECT utm_source,
	COUNT(DISTINCT website_session_id) as session_count
FROM website_sessions
GROUP BY utm_source
ORDER BY session_count DESC;

-- Session percentage per source:
SELECT utm_source,
	COUNT(DISTINCT website_session_id) as session_count,
  (COUNT(DISTINCT website_session_id) 
   / 
  (SELECT COUNT(DISTINCT website_session_id) FROM website_sessions)
  ) * 100 as session_percentage
FROM website_sessions
GROUP BY utm_source
ORDER BY session_count DESC;

-- Session count per device type:
SELECT device_type,
	COUNT(DISTINCT website_session_id) as session_count
FROM website_sessions
GROUP BY device_type;

-- Monthly session count:
SELECT YEAR(created_at) as year, MONTH(created_at) as month, 
	COUNT(DISTINCT website_session_id) as monthly_session_count
FROM website_sessions
GROUP BY YEAR(created_at), MONTH(created_at)
ORDER BY year, month;

-- Daily session count:
SELECT DATE(created_at) as days, 
	COUNT(DISTINCT website_session_id) as daily_session_count
FROM website_sessions
GROUP BY DATE(created_at)
ORDER BY days DESC;

-- Hourly session count:
SELECT DATE(created_at) as days, HOUR(created_at) as hours,
	COUNT(DISTINCT website_session_id) as hourly_session_count
FROM website_sessions
GROUP BY DATE(created_at), HOUR(created_at)
ORDER BY days DESC, hours;

-- Monthly active user(MAU) count: 
SELECT YEAR(created_at) as years, MONTH(created_at) as months,
	COUNT(DISTINCT user_id) as monthly_active_user
FROM website_sessions
GROUP BY YEAR(created_at), MONTH(created_at)
ORDER BY years, months;
	
-- Daily active user(DAU) count: 
SELECT DATE(created_at) as days,
	COUNT(DISTINCT user_id) as daily_active_user
FROM website_sessions
GROUP BY DATE(created_at)
ORDER BY days;

-- 2. Traffic to order conversion:

SELECT
  w.utm_source,
  w.utm_campaign,
  COUNT(DISTINCT w.website_session_id) AS sessions,
  COUNT(DISTINCT o.order_id) AS orders,
  COUNT(DISTINCT o.order_id) / COUNT(DISTINCT w.website_session_id) session_to_order_conversion
FROM
  website_sessions w
  LEFT JOIN orders o on w.website_session_id = o.website_session_id
GROUP BY
 w.utm_source,
 w.utm_campaign
ORDER BY
 session_to_order_conversion DESC;
 
-- Quarterly session to order conversation rate:

SELECT
YEAR(w.created_at) AS years,
    QUARTER(w.created_at) AS quarters,
    COUNT(DISTINCT o.order_id)/COUNT(DISTINCT w.website_session_id) AS session_to_order_conversion,
    ROUND(SUM(price_usd)/COUNT(DISTINCT o.order_id),2) AS revenue_per_order,
    ROUND(SUM(price_usd)/COUNT(DISTINCT w.website_session_id),2) AS revenue_per_session
FROM
    website_sessions w LEFT JOIN orders o ON w.website_session_id = o.website_session_id
GROUP BY YEAR(w.created_at),QUARTER(w.created_at)
ORDER BY years,quarters;

-- 3. Analyzing revenue by product and seasonality:

SELECT
    YEAR(created_at) AS years,
    MONTH(created_at) AS months,
    SUM(CASE WHEN product_id = 1 THEN price_usd ELSE NULL END) AS mrfuzzybr_rev,
    SUM(CASE WHEN product_id = 2 THEN price_usd ELSE NULL END) AS lovebr_rev,
    SUM(CASE WHEN product_id = 3 THEN price_usd ELSE NULL END) AS bdaybr_rev,
    SUM(CASE WHEN product_id = 4 THEN price_usd ELSE NULL END) AS minibr_rev,
    SUM(price_usd) AS total_revenue,
    SUM(price_usd - cogs_usd) AS total_margin
FROM order_items
GROUP BY YEAR(created_at),MONTH(created_at)
ORDER BY years,months;
