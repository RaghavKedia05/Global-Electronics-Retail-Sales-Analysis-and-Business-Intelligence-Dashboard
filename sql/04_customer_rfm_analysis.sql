-- Phase 4: Customer Analysis
-- The cleaned CSV should be loaded into a table named cleaned_sales.

-- 1. Customer-wise sales, profit, and order count
SELECT
    CustomerKey,
    [Name],
    ROUND(SUM([Sales USD]), 2) AS revenue,
    ROUND(SUM([Profit USD]), 2) AS profit,
    COUNT(DISTINCT [Order Number]) AS orders
FROM cleaned_sales
GROUP BY CustomerKey, [Name]
ORDER BY revenue DESC;

-- 2. Repeat customers
SELECT
    CustomerKey,
    [Name],
    COUNT(DISTINCT [Order Number]) AS orders
FROM cleaned_sales
GROUP BY CustomerKey, [Name]
HAVING COUNT(DISTINCT [Order Number]) > 1
ORDER BY orders DESC;

-- 3. Top 20 customers by revenue
SELECT TOP 20
    CustomerKey,
    [Name],
    ROUND(SUM([Sales USD]), 2) AS revenue,
    ROUND(SUM([Profit USD]), 2) AS profit,
    COUNT(DISTINCT [Order Number]) AS orders
FROM cleaned_sales
GROUP BY CustomerKey, [Name]
ORDER BY revenue DESC;

-- 4. Customers contributing the first 80% of revenue
WITH customer_revenue AS (
    SELECT
        CustomerKey,
        [Name],
        SUM([Sales USD]) AS revenue
    FROM cleaned_sales
    GROUP BY CustomerKey, [Name]
),
customer_contribution AS (
    SELECT
        CustomerKey,
        [Name],
        revenue,
        SUM(revenue) OVER (ORDER BY revenue DESC) AS cumulative_revenue,
        SUM(revenue) OVER () AS total_revenue
    FROM customer_revenue
)
SELECT
    CustomerKey,
    [Name],
    ROUND(revenue, 2) AS revenue,
    ROUND(cumulative_revenue * 100.0 / total_revenue, 2) AS cumulative_revenue_percent
FROM customer_contribution
WHERE (cumulative_revenue - revenue) * 100.0 / total_revenue < 80
ORDER BY revenue DESC;

-- 5. Customer retention rate based on repeat customers
WITH customer_orders AS (
    SELECT
        CustomerKey,
        COUNT(DISTINCT [Order Number]) AS orders
    FROM cleaned_sales
    GROUP BY CustomerKey
)
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN orders > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(
        SUM(CASE WHEN orders > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS retention_rate_percent
FROM customer_orders;

-- 6. RFM analysis and customer segments
WITH snapshot AS (
    SELECT DATEADD(day, 1, MAX([Order Date])) AS snapshot_date
    FROM cleaned_sales
),
rfm_values AS (
    SELECT
        CustomerKey,
        [Name],
        DATEDIFF(day, MAX([Order Date]), MAX(snapshot.snapshot_date)) AS recency,
        COUNT(DISTINCT [Order Number]) AS frequency,
        SUM([Sales USD]) AS monetary,
        SUM([Profit USD]) AS profit
    FROM cleaned_sales
    CROSS JOIN snapshot
    GROUP BY CustomerKey, [Name]
),
rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM rfm_values
),
rfm_total AS (
    SELECT
        *,
        r_score + f_score + m_score AS rfm_score
    FROM rfm_scores
)
SELECT
    CustomerKey,
    [Name],
    recency,
    frequency,
    ROUND(monetary, 2) AS monetary,
    ROUND(profit, 2) AS profit,
    r_score,
    f_score,
    m_score,
    rfm_score,
    CASE
        WHEN rfm_score >= 13 THEN 'Champions'
        WHEN rfm_score >= 10 THEN 'Loyal Customers'
        WHEN rfm_score >= 7 THEN 'Potential Loyalists'
        WHEN rfm_score >= 4 THEN 'At Risk'
        ELSE 'Lost Customers'
    END AS customer_segment
FROM rfm_total
ORDER BY monetary DESC;
