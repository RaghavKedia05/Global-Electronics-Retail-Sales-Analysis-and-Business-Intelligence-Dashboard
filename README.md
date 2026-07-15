# Global Electronics Retail Analytics

This project analyzes electronics retail sales using Python, SQL, and Power BI. It covers sales, products, customers, countries, stores, forecasting, market-basket analysis, and profitability.

## Datasets

| File | Records | Description |
|---|---:|---|
| `Sales.csv` | 62,884 | Order-line transactions |
| `Customers.csv` | 15,266 | Customer details |
| `Products.csv` | 2,517 | Product, category, cost, and price details |
| `Stores.csv` | 67 | Store location and size details |
| `Exchange_Rates.csv` | 11,215 | Daily exchange rates |
| `Data_Dictionary.csv` | 37 | Source-column definitions |

The source CSV files belong in `data/raw/`. Generated CSV files are saved in `data/processed/` and are not committed to Git.

## Project phases

### Phase 1: Data Understanding

- Total records and columns
- Data types
- Missing values
- Duplicate records
- Transaction count and date range
- Data dictionary

Notebook: [01_data_understanding.ipynb](notebooks/01_data_understanding.ipynb)

### Phase 2: Data Cleaning and Preparation

- Remove duplicates
- Handle missing values
- Standardize dates
- Check invalid sales values
- Create the required date, margin, and sales-category columns
- Save the cleaned dataset

Files:

- [02_data_cleaning.ipynb](notebooks/02_data_cleaning.ipynb)
- [Data cleaning documentation](docs/data_cleaning_documentation.md)
- `data/processed/cleaned_sales.csv`

### Phase 3: Sales Analysis

- Overall KPIs
- Yearly, quarterly, and monthly trends
- Category and subcategory performance
- Top, bottom, and loss-making products

Files:

- [03_sales_product_analysis.ipynb](notebooks/03_sales_product_analysis.ipynb)
- [03_sales_product_analysis.sql](sql/03_sales_product_analysis.sql)

### Phase 4: Customer Analysis

- Customer sales and profit
- Repeat customers and retention rate
- Top 20 customers
- Customers contributing the first 80% of revenue
- RFM analysis and customer segments

Files:

- [04_customer_rfm_analysis.ipynb](notebooks/04_customer_rfm_analysis.ipynb)
- [04_customer_rfm_analysis.sql](sql/04_customer_rfm_analysis.sql)
- `data/processed/customer_segments.csv`

### Phase 5: Geographic and Store Analysis

- Country sales, profit, customer count, and margin
- Best and worst countries
- Store sales, profit, orders, rankings, and growth

Files:

- [05_geographic_store_analysis.ipynb](notebooks/05_geographic_store_analysis.ipynb)
- [05_geographic_store_analysis.sql](sql/05_geographic_store_analysis.sql)
- `data/processed/country_performance.csv`
- `data/processed/store_performance.csv`
- `data/processed/store_growth.csv`

### Phase 6: Dashboard and Advanced Analysis

- Three- and six-month sales forecasts
- Market-basket analysis
- Product profitability groups
- Executive, Store Performance, and Customer Power BI pages

Files:

- [06_forecasting_basket_analysis.ipynb](notebooks/06_forecasting_basket_analysis.ipynb)
- [Power BI build steps](powerbi/dashboard_build.md)
- [DAX measures](powerbi/measures.dax)
- [Power BI theme](powerbi/theme.json)
- `data/processed/forecast_validation.csv`
- `data/processed/sales_forecast.csv`
- `data/processed/market_basket.csv`
- `data/processed/product_profitability.csv`

The `.pbix` file must be created in Power BI Desktop using the prepared data, DAX measures, theme, and page layout.

## Setup

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
jupyter lab
```

Run the notebooks in numerical order.

## Repository structure

```text
data/           Raw and processed data
docs/           Data cleaning documentation
notebooks/      Python analysis notebooks
powerbi/        DAX, theme, and dashboard instructions
presentation/   Final presentation files
reports/        Written reports and exported figures
sql/            SQL analysis queries
```

## License

This project uses the [MIT License](LICENSE).
