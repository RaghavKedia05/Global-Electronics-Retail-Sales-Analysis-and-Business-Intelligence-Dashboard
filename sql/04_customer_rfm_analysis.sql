-- Phase 4: Customer Analysis

-- Customer sales, gross profit, and order count
SELECT
    CustomerKey,
    ROUND(SUM([Revenue USD]), 2) AS revenue,
    ROUND(SUM([Gross Profit USD]), 2) AS gross_profit,
    COUNT(DISTINCT [Order Number]) AS orders
FROM cleaned_sales
GROUP BY CustomerKey
ORDER BY revenue DESC;

-- Repeat customers
SELECT
    CustomerKey,
    COUNT(DISTINCT [Order Number]) AS orders
FROM cleaned_sales
GROUP BY CustomerKey
HAVING COUNT(DISTINCT [Order Number]) > 1
ORDER BY orders DESC;

-- Top 20 customers by revenue
SELECT TOP 20
    CustomerKey,
    ROUND(SUM([Revenue USD]), 2) AS revenue,
    ROUND(SUM([Gross Profit USD]), 2) AS gross_profit
FROM cleaned_sales
GROUP BY CustomerKey
ORDER BY revenue DESC;

-- Customers contributing the first 80 percent of revenue
WITH customer_revenue AS (
    SELECT CustomerKey, SUM([Revenue USD]) AS revenue
    FROM cleaned_sales
    GROUP BY CustomerKey
),
customer_contribution AS (
    SELECT
        CustomerKey,
        revenue,
        SUM(revenue) OVER (ORDER BY revenue DESC, CustomerKey) AS cumulative_revenue,
        SUM(revenue) OVER () AS total_revenue
    FROM customer_revenue
)
SELECT
    CustomerKey,
    ROUND(revenue, 2) AS revenue,
    ROUND(cumulative_revenue * 100.0 / total_revenue, 2) AS cumulative_revenue_percent
FROM customer_contribution
WHERE (cumulative_revenue - revenue) * 100.0 / total_revenue < 80
ORDER BY revenue DESC;

-- Retention using the last two complete calendar years
WITH complete_years AS (
    SELECT [Year]
    FROM cleaned_sales
    GROUP BY [Year]
    HAVING COUNT(DISTINCT [Month]) = 12
),
retention_period AS (
    SELECT MAX([Year]) AS retention_year
    FROM complete_years
),
base_customers AS (
    SELECT DISTINCT CustomerKey
    FROM cleaned_sales
    CROSS JOIN retention_period
    WHERE [Year] = retention_year - 1
),
returning_customers AS (
    SELECT DISTINCT CustomerKey
    FROM cleaned_sales
    CROSS JOIN retention_period
    WHERE [Year] = retention_year
)
SELECT
    retention_year - 1 AS base_year,
    retention_year,
    COUNT(*) AS base_customers,
    SUM(CASE WHEN returning_customers.CustomerKey IS NOT NULL THEN 1 ELSE 0 END) AS retained_customers,
    ROUND(
        SUM(CASE WHEN returning_customers.CustomerKey IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS retention_rate_percent
FROM base_customers
CROSS JOIN retention_period
LEFT JOIN returning_customers
    ON base_customers.CustomerKey = returning_customers.CustomerKey
GROUP BY retention_year;

-- RFM values, scores, and segments
WITH snapshot AS (
    SELECT DATEADD(day, 1, MAX([Order Date])) AS snapshot_date
    FROM cleaned_sales
),
rfm_values AS (
    SELECT
        CustomerKey,
        MIN([Order Date]) AS first_purchase_date,
        MAX([Order Date]) AS last_purchase_date,
        DATEDIFF(day, MAX([Order Date]), MAX(snapshot.snapshot_date)) AS recency,
        COUNT(DISTINCT [Order Number]) AS frequency,
        SUM([Revenue USD]) AS monetary,
        SUM([Gross Profit USD]) AS gross_profit
    FROM cleaned_sales
    CROSS JOIN snapshot
    GROUP BY CustomerKey
),
rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency DESC, CustomerKey) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC, CustomerKey) AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC, CustomerKey) AS m_score
    FROM rfm_values
),
rfm_total AS (
    SELECT *, r_score + f_score + m_score AS rfm_score
    FROM rfm_scores
)
SELECT
    *,
    CASE
        WHEN rfm_score >= 13 THEN 'Champions'
        WHEN rfm_score >= 10 THEN 'Loyal Customers'
        WHEN rfm_score >= 7 THEN 'Potential Loyalists'
        WHEN rfm_score >= 4 THEN 'At Risk'
        ELSE 'Lost Customers'
    END AS customer_segment
FROM rfm_total
ORDER BY monetary DESC;
