# Data Cleaning Documentation

## Dataset

The Sales, Products, Customers, and Stores tables were combined to create `data/processed/cleaned_sales.csv`.

- Input sales records: 62,884
- Output records: 62,884
- Output columns: 41

## Cleaning steps

### Duplicate records

Complete duplicate rows were checked in Customers, Products, Sales, and Stores. No duplicate rows were found.

### Missing values

- `Delivery Date` contains 49,719 blank values. These rows belong to store purchases that do not require delivery, so the values were left blank.
- `Square Meters` was blank for `StoreKey = 0`, which represents the online store. It was changed to `0` because an online store has no physical area.

### Date formats

The following columns were converted to `YYYY-MM-DD` format:

- Order Date
- Delivery Date
- Birthday
- Open Date

### Invalid sales values

The data was checked for:

- Quantity less than or equal to zero
- Unit Cost USD less than zero
- Unit Price USD less than or equal to zero

No invalid values were found.

### Price and cost columns

Dollar signs, commas, and extra spaces were removed from `Unit Cost USD` and `Unit Price USD`. Both columns were converted to numeric values.

## Derived columns

| Column | Calculation |
|---|---|
| Year | Year from Order Date |
| Quarter | Quarter from Order Date |
| Month | Month number from Order Date |
| Month Name | Month name from Order Date |
| Day of Week | Day name from Order Date |
| Revenue USD | Quantity × Unit Price USD |
| Cost USD | Quantity × Unit Cost USD |
| Gross Profit USD | Revenue USD − Cost USD |
| Gross Margin % | Gross Profit USD ÷ Revenue USD × 100 |
| Sales Category | Revenue USD divided into three equally sized groups: Low, Medium, and High |

Sales categories are relative to this dataset. They are intended for comparison and are not company-approved pricing thresholds.

## Final validation

- Output records: 62,884
- Duplicate output records: 0
- Blank Square Meters values: 0
- Invalid quantities: 0
- Invalid product costs: 0
- Invalid product prices: 0
