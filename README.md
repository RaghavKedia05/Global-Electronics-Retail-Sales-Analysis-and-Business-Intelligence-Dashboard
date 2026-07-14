# Global Electronics Retail Analytics & BI Dashboard

[![Project Status](https://img.shields.io/badge/status-planning%20%26%20profiling-2563EB)](#project-roadmap)
[![Python](https://img.shields.io/badge/Python-3.10%2B-3776AB?logo=python&logoColor=white)](requirements.txt)
[![Power BI](https://img.shields.io/badge/Power%20BI-dashboard-F2C811?logo=powerbi&logoColor=111)](powerbi/README.md)
[![License](https://img.shields.io/badge/license-MIT-16A34A)](LICENSE)

An end-to-end retail analytics project that transforms multi-country electronics sales data into a clean analytical model, reproducible analysis, customer and store insights, forecasts, and an executive Power BI dashboard.

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

### Phase 1 — Data understanding and profiling (Week 1) — start here

- Inventory files, schemas, encodings, data types, row counts, and date ranges.
- Measure nulls, duplicates, invalid keys, inconsistent values, and referential-integrity failures.
- Confirm grain: one row per order line (`Order Number` + `Line Item`).
- Validate currency coverage and the business meaning of special keys such as `StoreKey = 0`.
- Produce a profiling report and finalized data dictionary.

**Deliverables:** profiling notebook, data-quality summary, relationship map, and updated data dictionary.

### Phase 2 — Cleaning and preparation (Week 2)

- Remove confirmed duplicates and define documented missing-value rules.
- Parse dates and currency fields; standardize names and column conventions.
- Validate positive quantities, prices, costs, exchange rates, and delivery dates.
- Join the six datasets into a reproducible star schema or analytical table.
- Add Year, Quarter, Month, Month Name, Day of Week, Profit Margin %, and Sales Category.

**Deliverables:** cleaned datasets in `data/processed/`, cleaning notebook/script, and cleaning report.

### Phase 3 — Sales and product analysis (Week 3)

- Calculate revenue, profit, orders, customers, average order value, and margin.
- Analyze yearly, quarterly, and monthly trends, growth, and seasonality.
- Rank categories, subcategories, brands, and products by sales and profit.
- Identify loss-making and high-sales/low-margin products.

**Deliverables:** KPI analysis notebook, SQL queries, figures, and findings report.

### Phase 4 — Customer analytics (Week 4)

- Measure customer revenue, profit, order frequency, repeat behavior, and retention.
- Run Pareto analysis to find customers contributing roughly 80% of revenue.
- Calculate Recency, Frequency, and Monetary value at a documented snapshot date.
- Segment customers into Champions, Loyal, Potential Loyalists, At Risk, and Lost.

**Deliverables:** RFM table, segmentation notebook, and customer insight report.

### Phase 5 — Geographic and store analysis (Week 5)

- Compare countries by revenue, profit, customer count, growth, and margin.
- Rank stores by revenue, profit, orders, and growth.
- Normalize store performance where useful (for example, revenue per square meter).
- Separate physical-store and online performance after channel validation.

**Deliverables:** geographic/store notebook, rankings, maps, and recommendations.

### Phase 6 — Dashboard, advanced analytics, and presentation (Week 6)

- Build Executive, Store Performance, and Customer pages in Power BI.
- Forecast three- and six-month sales using baselines such as moving average and linear regression; report validation error.
- Perform order-level market-basket analysis using support, confidence, and lift.
- Convert findings into prioritized, evidence-based business recommendations.
- Prepare a 15–20 slide stakeholder presentation with dashboard screenshots.

**Deliverables:** `.pbix` dashboard, forecast and basket-analysis outputs, business insight report, and presentation.

## What to do now

1. Copy the six untouched CSV files into `data/raw/`.
2. Create and activate a Python virtual environment.
3. Install dependencies with `pip install -r requirements.txt`.
4. Complete `notebooks/01_data_understanding.ipynb` and export the profiling results to `reports/`.
5. Record every issue and proposed treatment before changing data.
6. Define Phase 1 acceptance checks: row counts reconcile, composite sales key is tested, all joins are measured, and date/currency coverage is documented.

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
