# Power BI Dashboard

## Import files

Import these files from `data/processed/`:

- `cleaned_sales.csv`
- `customer_segments.csv`

Set `Order Date`, `Delivery Date`, `First_Purchase_Date`, and `Last_Purchase_Date` to the Date data type. Set revenue, gross profit, margin, monetary, and cost fields to Decimal Number.

## Data model

1. Create the Date Table from `measures.dax`.
2. Mark it as the date table using its Date column.
3. Create a one-to-many relationship from `Date Table[Date]` to `cleaned_sales[Order Date]`.
4. Create a one-to-many relationship from `customer_segments[CustomerKey]` to `cleaned_sales[CustomerKey]`.
5. Add the calculated columns and measures from `measures.dax`.
6. Import `theme.json` from View > Themes > Browse for themes.

## Page 1 - Executive Dashboard

- Cards: Total Revenue, Total Gross Profit, Total Orders, Total Customers, and Gross Margin %.
- Line chart: Date Table Year Month and Total Revenue.
- Bar chart: Country_Customer and Total Revenue.
- Column chart: Category and Total Revenue.
- Table: Product Name, Total Revenue, and Total Gross Profit; apply a Top 10 revenue filter.
- Table: Name, Total Revenue, and Total Gross Profit; apply a Top 10 revenue filter.
- Slicers: Year, Country_Customer, Category, and StoreKey.

## Page 2 - Store Performance

- Bar chart: StoreKey and Total Revenue.
- Bar chart: StoreKey and Total Gross Profit.
- Table: Store Rank, StoreKey, Country_Store, State_Store, Total Revenue, Total Gross Profit, and Total Orders.
- Line chart: Date Table Year and Total Revenue with StoreKey as the legend.
- Map: Country_Store and State_Store, sized by Total Revenue.
- Slicers: Year and Country_Store.

## Page 3 - Customer Dashboard

- Donut chart: Customer Segment and customer count from `customer_segments`.
- Scatter chart: Frequency on the X-axis, Monetary on the Y-axis, Recency as size, and Customer Segment as legend.
- Table: Name, Monetary, Gross_Profit, Frequency, Recency, and Customer Segment; apply a Top 20 Monetary filter.
- Line chart: Date Table Year Month and New Customers.
- Cards: Total Customers, Repeat Customers, and Customer Retention Rate.
- Slicers: Customer Segment and Year.
