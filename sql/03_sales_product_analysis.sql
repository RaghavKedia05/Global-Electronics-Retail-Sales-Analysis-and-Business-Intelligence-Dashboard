-- Phase 3: Sales and Product Analysis
-- The cleaned CSV should be loaded into a table named cleaned_sales.

-- 1. Overall KPIs
SELECT
    ROUND(SUM([Revenue USD]), 2) AS total_revenue,
    ROUND(SUM([Gross Profit USD]), 2) AS total_gross_profit,
    COUNT(DISTINCT [Order Number]) AS total_orders,
    COUNT(DISTINCT CustomerKey) AS total_customers,
    ROUND(SUM([Revenue USD]) / COUNT(DISTINCT [Order Number]), 2) AS average_order_value,
    ROUND(SUM([Gross Profit USD]) * 100.0 / SUM([Revenue USD]), 2) AS gross_margin_percent
FROM cleaned_sales;

-- 2. Yearly sales and growth
WITH yearly_sales AS (
    SELECT
        [Year],
        SUM([Revenue USD]) AS revenue
    FROM cleaned_sales
    GROUP BY [Year]
)
SELECT
    [Year],
    ROUND(revenue, 2) AS revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY [Year])) * 100.0
        / LAG(revenue) OVER (ORDER BY [Year]),
        2
    ) AS growth_percent
FROM yearly_sales
ORDER BY [Year];

-- 3. Quarterly sales
SELECT
    [Year],
    [Quarter],
    ROUND(SUM([Revenue USD]), 2) AS revenue
FROM cleaned_sales
GROUP BY [Year], [Quarter]
ORDER BY [Year], [Quarter];

-- 4. Monthly sales trend
SELECT
    [Year],
    [Month],
    [Month Name],
    ROUND(SUM([Revenue USD]), 2) AS revenue
FROM cleaned_sales
GROUP BY [Year], [Month], [Month Name]
ORDER BY [Year], [Month];

-- 5. Sales by month name
SELECT
    [Month],
    [Month Name],
    ROUND(SUM([Revenue USD]), 2) AS revenue
FROM cleaned_sales
GROUP BY [Month], [Month Name]
ORDER BY revenue DESC;

-- 6. Average sales by month for seasonality
WITH monthly_sales AS (
    SELECT
        [Year],
        [Month],
        [Month Name],
        SUM([Revenue USD]) AS revenue
    FROM cleaned_sales
    GROUP BY [Year], [Month], [Month Name]
)
SELECT
    [Month],
    [Month Name],
    ROUND(AVG(revenue), 2) AS average_monthly_sales
FROM monthly_sales
GROUP BY [Month], [Month Name]
ORDER BY [Month];

-- 7. Category performance
SELECT
    Category,
    ROUND(SUM([Revenue USD]), 2) AS revenue,
    ROUND(SUM([Gross Profit USD]), 2) AS gross_profit,
    COUNT(DISTINCT [Order Number]) AS orders
FROM cleaned_sales
GROUP BY Category
ORDER BY revenue DESC;

-- 8. Subcategory performance
SELECT
    Category,
    Subcategory,
    ROUND(SUM([Revenue USD]), 2) AS revenue,
    ROUND(SUM([Gross Profit USD]), 2) AS gross_profit,
    COUNT(DISTINCT [Order Number]) AS orders
FROM cleaned_sales
GROUP BY Category, Subcategory
ORDER BY revenue DESC;

-- 9. Top 10 products by sales
SELECT TOP 10
    ProductKey,
    [Product Name],
    ROUND(SUM([Revenue USD]), 2) AS revenue,
    ROUND(SUM([Gross Profit USD]), 2) AS gross_profit
FROM cleaned_sales
GROUP BY ProductKey, [Product Name]
ORDER BY revenue DESC;

-- 10. Top 10 products by profit
SELECT TOP 10
    ProductKey,
    [Product Name],
    ROUND(SUM([Revenue USD]), 2) AS revenue,
    ROUND(SUM([Gross Profit USD]), 2) AS gross_profit
FROM cleaned_sales
GROUP BY ProductKey, [Product Name]
ORDER BY gross_profit DESC;

-- 11. Bottom 10 products by sales
SELECT TOP 10
    ProductKey,
    [Product Name],
    ROUND(SUM([Revenue USD]), 2) AS revenue,
    ROUND(SUM([Gross Profit USD]), 2) AS gross_profit
FROM cleaned_sales
GROUP BY ProductKey, [Product Name]
ORDER BY revenue ASC;

-- 12. Products that generate losses
SELECT
    ProductKey,
    [Product Name],
    ROUND(SUM([Revenue USD]), 2) AS revenue,
    ROUND(SUM([Gross Profit USD]), 2) AS gross_profit
FROM cleaned_sales
GROUP BY ProductKey, [Product Name]
HAVING SUM([Gross Profit USD]) < 0
ORDER BY gross_profit ASC;
