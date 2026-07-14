-- Phase 5: Geographic and Store Analysis
-- The cleaned CSV should be loaded into a table named cleaned_sales.

-- 1. Country performance based on customer country
SELECT
    Country_Customer AS country,
    ROUND(SUM([Sales USD]), 2) AS revenue,
    ROUND(SUM([Profit USD]), 2) AS profit,
    COUNT(DISTINCT CustomerKey) AS customers,
    COUNT(DISTINCT [Order Number]) AS orders,
    ROUND(SUM([Profit USD]) * 100.0 / SUM([Sales USD]), 2) AS profit_margin_percent
FROM cleaned_sales
GROUP BY Country_Customer
ORDER BY revenue DESC;

-- 2. Best-performing country
SELECT TOP 1
    Country_Customer AS country,
    ROUND(SUM([Sales USD]), 2) AS revenue
FROM cleaned_sales
GROUP BY Country_Customer
ORDER BY revenue DESC;

-- 3. Worst-performing country
SELECT TOP 1
    Country_Customer AS country,
    ROUND(SUM([Sales USD]), 2) AS revenue
FROM cleaned_sales
GROUP BY Country_Customer
ORDER BY revenue ASC;

-- 4. Country with the highest profit margin
SELECT TOP 1
    Country_Customer AS country,
    ROUND(SUM([Profit USD]) * 100.0 / SUM([Sales USD]), 2) AS profit_margin_percent
FROM cleaned_sales
GROUP BY Country_Customer
ORDER BY profit_margin_percent DESC;

-- 5. Store performance
SELECT
    StoreKey,
    Country_Store,
    State_Store,
    ROUND(SUM([Sales USD]), 2) AS revenue,
    ROUND(SUM([Profit USD]), 2) AS profit,
    COUNT(DISTINCT [Order Number]) AS orders,
    ROUND(SUM([Profit USD]) * 100.0 / SUM([Sales USD]), 2) AS profit_margin_percent
FROM cleaned_sales
GROUP BY StoreKey, Country_Store, State_Store
ORDER BY revenue DESC;

-- 6. Top 10 stores
SELECT TOP 10
    StoreKey,
    Country_Store,
    State_Store,
    ROUND(SUM([Sales USD]), 2) AS revenue,
    ROUND(SUM([Profit USD]), 2) AS profit,
    COUNT(DISTINCT [Order Number]) AS orders
FROM cleaned_sales
GROUP BY StoreKey, Country_Store, State_Store
ORDER BY revenue DESC;

-- 7. Ten lowest-performing stores
SELECT TOP 10
    StoreKey,
    Country_Store,
    State_Store,
    ROUND(SUM([Sales USD]), 2) AS revenue,
    ROUND(SUM([Profit USD]), 2) AS profit,
    COUNT(DISTINCT [Order Number]) AS orders
FROM cleaned_sales
GROUP BY StoreKey, Country_Store, State_Store
ORDER BY revenue ASC;

-- 8. Yearly store growth
WITH yearly_store_sales AS (
    SELECT
        StoreKey,
        Country_Store,
        State_Store,
        [Year],
        SUM([Sales USD]) AS revenue
    FROM cleaned_sales
    GROUP BY StoreKey, Country_Store, State_Store, [Year]
),
store_growth AS (
    SELECT
        *,
        LAG(revenue) OVER (PARTITION BY StoreKey ORDER BY [Year]) AS previous_year_revenue
    FROM yearly_store_sales
)
SELECT
    StoreKey,
    Country_Store,
    State_Store,
    [Year],
    ROUND(revenue, 2) AS revenue,
    ROUND(previous_year_revenue, 2) AS previous_year_revenue,
    ROUND(
        (revenue - previous_year_revenue) * 100.0 / NULLIF(previous_year_revenue, 0),
        2
    ) AS growth_percent
FROM store_growth
ORDER BY StoreKey, [Year];
