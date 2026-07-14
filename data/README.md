# Data directories

- `raw/`: immutable copies of the six supplied CSV files.
- `interim/`: standardized or partially transformed datasets.
- `processed/`: validated, analysis-ready tables.

Do not commit customer-level source or generated data. Transformations must be reproducible from code.
