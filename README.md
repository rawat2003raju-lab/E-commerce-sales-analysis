# 🛒 E-commerce Sales Analysis

End-to-end e-commerce analytics project — from raw, messy transaction data to a clean dataset, a 20-query business insights suite, and an interactive executive dashboard.

**Stack:** Python (Pandas) → MySQL → Power BI

---

## 📌 Overview

This project simulates a real-world analytics workflow for an e-commerce business. It takes a raw, dirty sales dataset and carries it through the full pipeline:

1. **Data Cleaning (Python)** — fix inconsistent formatting, handle nulls, remove duplicates, and correct invalid values.
2. **Business Analysis (MySQL)** — answer 20 real business questions covering revenue, customers, products, geography, and discounting.
3. **Dashboarding (Power BI)** — visualize the cleaned data in an interactive executive dashboard.

---

## 🗂️ Repository Structure

| File | Description |
|---|---|
| `ecommerse_sales__analysis.py` | Python script that cleans the raw dataset (nulls, duplicates, text formatting, dates, negative values) and exports the cleaned CSV. |
| `Business_Questins_SQL20.sql` | MySQL script that creates the `sales` table and runs a 20-query business analysis suite. |
| `ecommerce_sales_dirty.csv` | Raw, uncleaned source dataset. |
| `ecommerce_sales_cleaned.csv` | Cleaned dataset produced by the Python script — used for SQL analysis and Power BI. |
| `ecommerce_sales_dashboard.pbix` | Power BI dashboard built on the cleaned data. |

---

## 🧹 Data Cleaning (Python)

The `ecommerse_sales__analysis.py` script prepares the raw data for analysis:

- Loads `ecommerce_sales_dirty.csv` with Pandas
- Removes duplicate rows
- Trims whitespace and standardizes text columns (title-cases `City` and `Category`)
- Converts mixed-format date strings in `Order_Date` into proper datetime objects
- Fills missing categorical values (e.g. `Customer_Name`, `City`, `State`, `Region`, `Sub_Category`, `Product_Name`) with `"Unknown"`
- Drops rows with missing critical numeric values (`Sales`, `Quantity`, `Discount`, `Profit`)
- Converts negative `Quantity`/`Sales` values to absolute values
- Caps `Discount` between `0.00` and `0.50`
- Exports the result to `ecommerce_sales_cleaned.csv`

**Run it:**
```bash
pip install pandas numpy seaborn matplotlib
python ecommerse_sales__analysis.py
```
> Note: the script currently reads from `/content/ecommerce_sales_dirty.csv` (a Colab path). Update this path to point to the local `ecommerce_sales_dirty.csv` before running outside Colab.

---

## 🗄️ Business Analysis (MySQL)

`Business_Questins_SQL20.sql` creates a `sales` table in an `ecommerce_db` database and runs 20 queries grouped into five sections:

1. **Sales & Revenue Performance** — total revenue/profit, average order value, monthly trends
2. **Product & Category Analysis** — top products, category margins, revenue vs. profit ranking, underperforming products
3. **Customer Analysis** — top customers, unprofitable customers, purchase frequency, repeat vs. one-time buyers, churn risk, RFM-style value tiers
4. **Geographic Performance** — revenue and margin by city, state, and region
5. **Discount vs. Profitability** — margin impact by discount band, optimal discount levels

**Run it:**
1. Import `ecommerce_sales_cleaned.csv` into the `sales` table created by the script (via MySQL Workbench's import wizard or `LOAD DATA INFILE`).
2. Execute the queries in `Business_Questins_SQL20.sql` in MySQL Workbench or your preferred MySQL client.

---

## 📊 Dashboard (Power BI)

`ecommerce_sales_dashboard.pbix` turns the cleaned data into an interactive executive dashboard covering revenue trends, top products/customers, regional performance, and discount impact.

**To view it:** open the file in [Power BI Desktop](https://www.microsoft.com/en-us/power-platform/products/power-bi/desktop) (free).

---

## 🚀 Getting Started

```bash
git clone https://github.com/rawat2003raju-lab/E-commerce-sales-analysis.git
cd E-commerce-sales-analysis
```

1. Run the Python script to clean the raw data (or use the pre-cleaned CSV already in the repo).
2. Load the cleaned CSV into MySQL and run the SQL analysis suite.
3. Open the `.pbix` file in Power BI Desktop to explore the dashboard.

---

## 🛠️ Tech Stack

- **Python** — Pandas, NumPy, Seaborn, Matplotlib
- **MySQL** — data storage and business-question queries
- **Power BI** — interactive dashboarding

---

## 📈 Key Business Questions Answered

- What are total revenue and profit, and how do they trend monthly?
- Which products and categories drive the most revenue vs. profit?
- Who are the top customers, and which customers are unprofitable?
- Which cities/regions perform best — and which lose money despite high sales?
- What discount levels maximize profit without eroding margins?
- Which customers are at risk of churn, and how are customers segmented by value?

---

## 👤 Author

**rawat2003raju-lab**
GitHub: [@rawat2003raju-lab](https://github.com/rawat2003raju-lab)




