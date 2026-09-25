# Indian IT Sector — Multi-Company Financial Health Comparison

A SQL + Power BI project comparing the financial health of India's top 5 IT services companies — **TCS, Infosys, Wipro, HCL Technologies, and Tech Mahindra** — across 5 years (FY22–FY26), using profitability, liquidity, and leverage ratios to benchmark performance and surface risk signals.

## Overview

- **25 company-years** of financial statement data (Revenue, COGS, Net Profit, Assets, Liabilities, Equity)
- Data sourced from [Screener.in](https://www.screener.in) (Profit & Loss and Balance Sheet statements)
- Cleaned and structured in Excel, loaded into **PostgreSQL**, analyzed with **SQL** (CTEs, window functions), and visualized in a 4-page **Power BI** dashboard with custom **DAX** measures

## Tools Used

`SQL (PostgreSQL)` · `Power BI` · `DAX` · `Excel`

## Dashboard

The dashboard has 4 pages:

| Page | What it shows |
|---|---|
| **Overview** | Sector-wide KPIs, revenue by company, company slicer |
| **Comparison** | Net Margin %, ROE %, and Current Ratio compared across companies |
| **Trend** | 5-year Net Margin % and YoY Revenue Growth % trend lines, by company |
| **Deep-Dive** | Company-level drill-down — KPIs, trend chart, and full financial detail table |

Screenshots are in the [`screenshots/`](./screenshots) folder.

## Key Metrics Calculated

- Gross Margin %, Net Margin %
- Return on Equity (ROE %), Return on Assets (ROA %)
- Current Ratio, Debt-to-Equity
- YoY Revenue Growth %, YoY Net Profit Growth %
- Rolling 3-year average margin (SQL window function)

## Key Insights

1. **TCS and Infosys** maintained the most consistent, strongest margins (18–20% Net Margin) across all 5 years.
2. **HCL Technologies and Tech Mahindra** showed a declining margin trend over the period.
3. **Tech Mahindra's FY24 net profit fell 51%** while revenue declined only 2% — a sign of margin compression distinct from top-line weakness — followed by an 80% profit recovery in FY25.
4. **Wipro's ROE never crossed 20%** in any of the 5 years, the weakest shareholder-return performance among the five companies, while TCS, Infosys, and HCL Technologies stayed above 20% every year.

## SQL Highlights

The [`sql/queries.sql`](./sql/queries.sql) file includes:
- Year-wise company ranking using `RANK() OVER (PARTITION BY ...)`
- A reusable ratio-calculation view built with a `WITH` CTE
- A rolling 3-year average margin using `AVG() OVER (... ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)`

## Data Note

Current Assets and Current Liabilities are not broken out in Screener.in's free-tier balance sheet export, so `Other Assets` and `Other Liabilities` were used as proxies for these values. This is a documented approximation, not exact accounting classification.

## Files in This Repo

- `data/` — cleaned master dataset (CSV)
- `sql/` — all SQL queries used in the analysis
- `powerbi/` — the Power BI (.pbix) dashboard file
- `screenshots/` — dashboard page exports
- `excel/` — the original data-collection template

## Author

**Srishti Kumari** — [LinkedIn](https://linkedin.com/in/srishti-kumari-632a55355) · [GitHub](https://github.com/Srishtisha-21) · [Medium](https://medium.com/@srishti1922sha)
