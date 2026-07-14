# Global Electronics Retail Analytics & BI Dashboard

[![Project Status](https://img.shields.io/badge/status-phase%201%20code%20complete-16A34A)](#phase-1-results)
[![Python](https://img.shields.io/badge/Python-3.10%2B-3776AB?logo=python&logoColor=white)](requirements.txt)
[![Power BI](https://img.shields.io/badge/Power%20BI-dashboard-F2C811?logo=powerbi&logoColor=111)](powerbi/README.md)
[![License](https://img.shields.io/badge/license-MIT-16A34A)](LICENSE)

An end-to-end retail analytics project focused on beginner-friendly Python analysis, reusable SQL queries, a clean analytical model, and an executive Power BI dashboard. Written reports and the final presentation are prepared separately by the project author.

## Business objective

Management needs a reliable view of revenue, profit, customers, products, countries, and stores. This project will answer:

- Which products, categories, countries, and stores create the most revenue and profit?
- Where are sales growing, declining, or showing seasonal patterns?
- Which customers are most valuable, loyal, at risk, or lost?
- Which products have high sales but weak profitability?
- What products are frequently purchased together?
- What sales levels can be expected over the next three to six months?

## Dataset overview

The source package contains six CSV files and 91,966 data rows in total (including the 37-row data dictionary).

| Dataset | Rows | Key fields | Purpose |
|---|---:|---|---|
| `Sales.csv` | 62,884 | Order Number, CustomerKey, StoreKey, ProductKey | Transaction line items |
| `Customers.csv` | 15,266 | CustomerKey | Customer and geographic attributes |
| `Exchange_Rates.csv` | 11,215 | Date, Currency | Daily currency-to-USD exchange rates |
| `Products.csv` | 2,517 | ProductKey | Product hierarchy, USD cost, and USD price |
| `Stores.csv` | 67 | StoreKey | Store geography, footprint, and opening date |
| `Data_Dictionary.csv` | 37 | Table, Field | Source-field definitions |

> Source data is intentionally not committed. Place the six CSV files in `data/raw/` and keep their original filenames. `Customers.csv` is Windows-1252 encoded; the other supplied files are UTF-8 compatible.

## Analytical model

`Sales` is the fact table. It joins to `Customers`, `Products`, and `Stores` by their keys, and to `Exchange_Rates` by order date and currency code.

```text
Customers (CustomerKey) ──┐
Products  (ProductKey)  ──┼──> Sales <── (StoreKey) Stores
Exchange Rates          ──┘       │
                         Date + Currency Code
```

Core measures will be validated during Phase 2:

```text
Revenue USD    = Quantity × Unit Price USD
Cost USD       = Quantity × Unit Cost USD
Profit USD     = Revenue USD − Cost USD
Profit Margin  = Profit USD ÷ Revenue USD
Average Order Value = Revenue USD ÷ Distinct Orders
```

The exchange-rate table will also be used to retain or reconstruct local-currency measures where needed. The meaning of `StoreKey = 0` (likely online sales) must be confirmed before store/channel reporting.

## Project roadmap

### Phase 1 — Data understanding and profiling (Week 1) — complete

- Inventory files, schemas, encodings, data types, row counts, and date ranges.
- Measure nulls, duplicates, invalid keys, inconsistent values, and referential-integrity failures.
- Confirm grain: one row per order line (`Order Number` + `Line Item`).
- Validate currency coverage and the business meaning of special keys such as `StoreKey = 0`.
- Produce a profiling report and finalized data dictionary.

**Technical deliverable:** beginner-friendly profiling notebook.

### Phase 2 — Cleaning and preparation (Week 2) — complete

- Remove confirmed duplicates and define documented missing-value rules.
- Parse dates and currency fields; standardize names and column conventions.
- Validate positive quantities, prices, costs, exchange rates, and delivery dates.
- Join the six datasets into a reproducible star schema or analytical table.
- Add Year, Quarter, Month, Month Name, Day of Week, Profit Margin %, and Sales Category.

**Deliverables:** cleaning notebook, cleaned dataset, and data cleaning documentation.

Completed files: [Phase 2 notebook](notebooks/02_data_cleaning.ipynb) and [data cleaning documentation](docs/data_cleaning_documentation.md). The generated cleaned dataset is stored at `data/processed/cleaned_sales.csv` and is excluded from Git.

### Phase 3 — Sales and product analysis (Week 3) — complete

- Calculate revenue, profit, orders, customers, average order value, and margin.
- Analyze yearly, quarterly, and monthly trends, growth, and seasonality.
- Rank categories, subcategories, brands, and products by sales and profit.
- Identify loss-making and high-sales/low-margin products.

**Technical deliverables:** KPI analysis notebook, reusable SQL queries, and Power BI-ready outputs.

Completed files: [Phase 3 notebook](notebooks/03_sales_product_analysis.ipynb) and [Phase 3 SQL queries](sql/03_sales_product_analysis.sql).

### Phase 4 — Customer analytics (Week 4) — complete

- Measure customer revenue, profit, order frequency, repeat behavior, and retention.
- Run Pareto analysis to find customers contributing roughly 80% of revenue.
- Calculate Recency, Frequency, and Monetary value at a documented snapshot date.
- Segment customers into Champions, Loyal, Potential Loyalists, At Risk, and Lost.

**Technical deliverables:** RFM table, segmentation notebook, SQL queries, and dashboard measures.

Completed files: [Phase 4 notebook](notebooks/04_customer_rfm_analysis.ipynb) and [Phase 4 SQL queries](sql/04_customer_rfm_analysis.sql). The generated customer segmentation dataset is stored at `data/processed/customer_segments.csv` and is excluded from Git.

### Phase 5 — Geographic and store analysis (Week 5) — complete

- Compare countries by revenue, profit, customer count, growth, and margin.
- Rank stores by revenue, profit, orders, and growth.
- Normalize store performance where useful (for example, revenue per square meter).
- Separate physical-store and online performance after channel validation.

**Technical deliverables:** geographic/store notebook, SQL queries, rankings, and dashboard visuals.

Completed files: [Phase 5 notebook](notebooks/05_geographic_store_analysis.ipynb) and [Phase 5 SQL queries](sql/05_geographic_store_analysis.sql). The generated country, store, and store-growth datasets are stored in `data/processed/` and are excluded from Git.

### Phase 6 — Dashboard, advanced analytics, and presentation (Week 6)

- Build Executive, Store Performance, and Customer pages in Power BI.
- Forecast three- and six-month sales using baselines such as moving average and linear regression; report validation error.
- Perform order-level market-basket analysis using support, confidence, and lift.
- Convert findings into prioritized, evidence-based business recommendations.
- Export dashboard screenshots that can be used by the project author in a separate presentation.

**Technical deliverables:** `.pbix` dashboard, DAX measures, forecast code, basket-analysis code, and Power BI-ready outputs.

## Phase 1 results

- 62,884 sales lines represent 26,326 distinct orders from 2016-01-01 through 2021-02-20.
- No unmatched customer, product, physical-store, or exchange-rate relationships were detected.
- No non-positive quantities/prices, delivery-before-order dates, or products with cost above list price were detected.
- 13,165 lines use `StoreKey = 0`; this should be confirmed and modeled as an online channel.
- 49,719 lines have no delivery date; the business meaning must be confirmed before treatment.
- Profiling checks are written directly in the Phase 1 notebook and display their results without generating a separate report.

See the [Phase 1 data-understanding notebook](notebooks/01_data_understanding.ipynb).

## What to do next

1. Confirm that `StoreKey = 0` means online sales.
2. Confirm whether blank delivery dates represent in-store purchases, pickup orders, or missing operational data.
3. Create and activate a Python virtual environment.
4. Install dependencies with `pip install -r requirements.txt`.
5. Start Phase 2 by defining cleaning rules and validation tests before producing processed data.

Do not begin dashboard design until the KPI definitions and cleaned model have passed validation.

## Repository structure

```text
.
├── data/
│   ├── raw/                 # Immutable source CSVs (not tracked)
│   ├── interim/             # Temporary standardized data
│   └── processed/           # Analysis-ready tables (not tracked)
├── docs/                    # Requirements, dictionary, and methodology
├── notebooks/               # Numbered exploration and analysis notebooks
├── powerbi/                 # PBIX file, theme, and dashboard notes
├── presentation/            # Final 15–20 slide deck
├── reports/
│   └── figures/             # Exported charts and dashboard screenshots
├── sql/                     # Reproducible schema and analysis queries
├── src/
│   ├── data/                # Ingestion, validation, and cleaning code
│   ├── features/            # KPI, date, RFM, and basket features
│   ├── analysis/            # Sales, customer, store, and forecast logic
│   └── visualization/       # Reusable plotting helpers
├── tests/                   # Data-quality and transformation tests
├── .gitignore
├── LICENSE
├── README.md
└── requirements.txt
```

## Reproducibility conventions

- Treat `data/raw/` as immutable; transformations must be implemented in notebooks, Python, SQL, Power Query, or DAX.
- Use snake_case for engineered columns and document every KPI formula.
- Aggregate orders with `COUNT(DISTINCT order_number)`, not sales row count.
- Keep exploratory notebooks readable, but move reusable logic into `src/`.
- Store generated data and large BI artifacts outside Git; publish screenshots and documentation instead.
- Never expose customer names or other personally identifiable information in public dashboard screenshots.

## Planned dashboard pages

1. **Executive Overview:** headline KPIs, monthly trend, category mix, country performance, and key insights.
2. **Product & Profitability:** category/subcategory drill-down, top and bottom products, margin quadrants.
3. **Store & Geography:** store rankings, regional comparison, growth, and revenue per square meter.
4. **Customer & RFM:** customer segments, repeat behavior, Pareto contribution, and customer growth.
5. **Advanced Insights:** forecast, product affinities, risks, and recommended actions.

## License

This repository is available under the [MIT License](LICENSE). Review the source dataset's own terms before redistributing any data.
