# Indian IT Sector — Multi-Company Financial Health Comparison
### Detailed Analysis Report

**Author:** Srishti Kumari
**Tools:** SQL (PostgreSQL), Power BI, DAX, Excel
**Period Covered:** FY22 – FY26 (5 years)
**Companies:** TCS, Infosys, Wipro, HCL Technologies, Tech Mahindra

---

## 1. Problem Statement

Investors, analysts, and internal finance teams routinely need to answer a simple but high-stakes question: **which company in a sector is genuinely the healthiest — not just the biggest?** Revenue size alone hides a lot: two companies can post similar top-line growth while one quietly loses profitability, over-leverages, or struggles with liquidity.

This project asks that question of India's five largest listed IT services companies. The goal was to move past headline revenue numbers and build a repeatable, data-driven framework to compare **profitability, liquidity, and leverage** across companies and over time — surfacing risks and strengths that a single year's numbers, or revenue figures alone, would not reveal.

## 2. Objective

- Build a clean, structured 5-year financial dataset for TCS, Infosys, Wipro, HCL Technologies, and Tech Mahindra
- Calculate and compare standard financial-health ratios across all five companies
- Identify trends, outliers, and risk signals using SQL and Power BI
- Translate the findings into concrete, decision-ready observations

## 3. Data Source & Scope

- **Source:** [Screener.in](https://www.screener.in) — Profit & Loss and Balance Sheet statements for each company, exported via their free data-export tool
- **Scope:** 5 companies × 5 fiscal years (FY22–FY26) = **25 company-year records**
- **Fields collected:** Revenue, COGS (total operating expenses), Operating Profit, Net Profit, Total Assets, Current Assets*, Total Liabilities, Current Liabilities*, Total Debt (Borrowings), Total Equity

*\*Current Assets and Current Liabilities are not broken out in Screener's free-tier balance sheet export. "Other Assets" and "Other Liabilities" were used as documented proxies — see Section 8, Limitations.*

## 4. Approach / Methodology

The project was built in four stages:

**Stage 1 — Data Collection & Cleaning (Excel)**
Financial statement data for all 5 companies was manually collected from Screener.in and structured into a single master table (one row per company-year), with all figures standardized to ₹ Crore. A validation check (Total Equity + Total Liabilities = Total Assets) was run on every row to catch entry errors before moving on.

**Stage 2 — Database & SQL Analysis (PostgreSQL)**
The cleaned dataset was loaded into a PostgreSQL table (`it_financials`). SQL was used to:
- Rank companies by revenue and margin within each year using `RANK() OVER (PARTITION BY year ...)`
- Build a reusable ratio-calculation layer using a `WITH` CTE, computing gross margin, net margin, ROE, ROA, current ratio, and debt-to-equity in one place
- Calculate a **rolling 3-year average net margin** per company using `AVG() OVER (PARTITION BY company ORDER BY year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)`, to smooth out year-to-year noise and reveal the underlying trend

**Stage 3 — Dashboard Build (Power BI + DAX)**
A 4-page interactive dashboard was built:
- **Overview** — sector-wide KPIs and a company slicer
- **Comparison** — side-by-side ratio comparison across all 5 companies
- **Trend** — 5-year line charts for Net Margin % and YoY Revenue Growth %, one line per company
- **Deep-Dive** — a company-level view with its own KPIs, trend line, and full financial detail table

Custom DAX measures were written for YoY Revenue Growth % and YoY Net Profit Growth %, using `VAR`/`RETURN` logic to look up each company's prior-year figures dynamically (since the `year` field is a text label like "FY23" rather than a date, standard time-intelligence functions could not be used directly).

**Stage 4 — Insight Extraction**
Once the dashboard was live, each page was reviewed specifically for outliers, divergences between related metrics (e.g., profit growth vs. revenue growth), and multi-year patterns rather than single-year snapshots.

## 5. Key Metrics Defined

| Metric | Formula | What it measures |
|---|---|---|
| Gross Margin % | (Revenue − COGS) / Revenue | Core operating efficiency |
| Net Margin % | Net Profit / Revenue | Overall profitability after all costs |
| ROE % | Net Profit / Total Equity | Return generated on shareholders' capital |
| ROA % | Net Profit / Total Assets | How efficiently assets generate profit |
| Current Ratio | Current Assets / Current Liabilities | Short-term liquidity / ability to cover near-term obligations |
| Debt-to-Equity | Total Debt / Total Equity | Financial leverage / reliance on borrowing |
| YoY Revenue Growth % | (Current Year − Prior Year) / Prior Year | Top-line momentum |
| YoY Net Profit Growth % | (Current Year − Prior Year) / Prior Year | Bottom-line momentum |

## 6. Findings

### 6.1 Profitability
- **TCS and Infosys** were the most consistently profitable companies in the group, sustaining net margins in the **18–20% range** across all 5 years with minimal year-to-year volatility.
- **HCL Technologies** showed a **steady, gradual decline** in net margin — from roughly 15.8% in FY22 down to approximately 12.8% by FY26 — indicating persistent, not one-off, margin pressure.
- **Tech Mahindra** was the most volatile of the five: net margin fell sharply from ~12.5% (FY22) to a low of ~4.5% (FY24), before partially recovering by FY26.
- **Wipro's** margins were mid-pack and relatively flat, neither improving nor deteriorating meaningfully over the period.

### 6.2 Shareholder Returns (ROE)
- **TCS, Infosys, and HCL Technologies** maintained ROE **above 20% in every single year** of the study period.
- **Wipro** never crossed the 20% ROE mark in any year — the only company in the group with this distinction, signaling comparatively weaker returns generated on shareholder capital despite reasonable margins.

### 6.3 The Tech Mahindra Anomaly (FY24)
This was the most significant single finding of the project. In FY24:
- Tech Mahindra's **revenue declined by only ~2%**
- But its **net profit collapsed by ~51%**

A revenue decline of that size should not, on its own, cause a profit collapse of that magnitude — the gap between the two numbers points to a **cost or margin-side problem**, not a demand problem. The company then recovered sharply, posting roughly **80% net profit growth in FY25**, suggesting the FY24 pressure (likely cost overruns, one-off charges, or pricing pressure) was addressed rather than structural.

### 6.4 Liquidity & Leverage
- **Wipro and HCL Technologies** carried the strongest current ratios in the group (highest short-term liquidity buffers).
- **Tech Mahindra** had the tightest current ratio among the five, consistent with the profitability stress observed in FY24.
- **Debt-to-equity ratios were low across the board (well under 0.15x for all 5 companies)** — a structural feature of the Indian IT services sector, which is asset-light and not capital-intensive, unlike manufacturing or infrastructure sectors.

## 7. Insights (Business Interpretation)

1. **Revenue growth alone is a misleading health signal in this sector.** Tech Mahindra's FY24 result is the clearest proof — a small revenue dip masked a severe profitability event that a revenue-only view would have completely missed.
2. **TCS and Infosys represent the "quality" profile** in this comparison: consistent margins + consistently high ROE, which typically commands a valuation premium and lower risk perception among investors.
3. **HCL Technologies' gradual margin erosion is a trend to watch, not a one-time event** — the rolling 3-year average confirms this is a multi-year drift rather than a single bad year.
4. **Wipro's low ROE despite decent margins and the strongest liquidity position** suggests capital is not being deployed as efficiently as peers — worth investigating further (e.g., higher idle cash, lower asset turnover).
5. **Low leverage sector-wide means debt risk is not the differentiator here — profitability and capital efficiency are.** Any comparison framework for this sector should weight margin stability and ROE more heavily than balance-sheet risk metrics.

## 8. Limitations

- **Current Assets / Current Liabilities are proxied** using "Other Assets" and "Other Liabilities" from Screener's simplified balance sheet export, since exact current/non-current classification was not available in the free data tier. Current ratio figures should be read as directional, not exact.
- **COGS is approximated as total operating expenses**, since IT services companies do not report a traditional manufacturing-style Cost of Goods Sold line.
- **5 years is a relatively short window** for judging long-term structural trends (e.g., HCL Technologies' margin decline); a 10-year view would strengthen confidence in the trend being persistent rather than cyclical.
- Figures are drawn from standalone/consolidated statements as presented by Screener.in; no adjustment was made for one-off items, restatements, or accounting-policy differences between companies.

## 9. Recommendations

Framed as if advising an analyst, investor, or internal strategy team using this comparison:

1. **Prioritize TCS and Infosys for stability-focused allocation** — both show the most predictable margin and return profile in the group.
2. **Flag HCL Technologies for a deeper margin-driver investigation** — the multi-year decline warrants understanding whether it is pricing pressure, wage inflation, or mix-shift driven, before it compounds further.
3. **Treat Tech Mahindra's FY24 event as a case study, not a red flag going forward** — the sharp FY25 recovery suggests the issue was addressed; however, continued monitoring of cost lines is warranted given the magnitude of the swing.
4. **Investigate Wipro's capital efficiency specifically** — with strong liquidity and moderate margins but the weakest ROE in the group, the gap likely lies in asset utilization or capital allocation rather than core profitability.
5. **For future iterations of this analysis, obtain full balance-sheet detail** (rather than the proxy current assets/liabilities used here) to sharpen the liquidity comparison.

## 10. Conclusion

Comparing five companies within the same sector on a common set of ratios — rather than relying on headline revenue or single-year profit numbers — surfaced patterns that would not have been visible otherwise: a profitability "quality tier" (TCS, Infosys), a slow-moving risk (HCL Technologies' margin drift), a sharp anomaly worth explaining (Tech Mahindra's FY24 profit collapse), and an efficiency question worth investigating (Wipro's ROE gap). This is the core value of structured financial comparison: it turns raw statements into a small number of specific, actionable questions.

---

## Appendix: Key SQL Queries

**Rolling 3-year average margin + within-year rank:**
```sql
SELECT
    company,
    year,
    ROUND(net_profit / revenue * 100, 2) AS net_margin_pct,
    ROUND(
        AVG(net_profit / revenue * 100) OVER (
            PARTITION BY company
            ORDER BY year
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 2
    ) AS rolling_3yr_avg_margin,
    RANK() OVER (
        PARTITION BY year
        ORDER BY (net_profit / revenue * 100) DESC
    ) AS margin_rank_in_year
FROM it_financials
ORDER BY company, year;
```

**Reusable ratio CTE:**
```sql
WITH company_ratios AS (
    SELECT
        company, year,
        ROUND((revenue - cogs) / revenue * 100, 2) AS gross_margin_pct,
        ROUND(net_profit / revenue * 100, 2) AS net_margin_pct,
        ROUND(net_profit / total_equity * 100, 2) AS roe_pct,
        ROUND(net_profit / total_assets * 100, 2) AS roa_pct,
        ROUND(current_assets / current_liabilities, 2) AS current_ratio,
        ROUND(total_debt / total_equity, 2) AS debt_to_equity
    FROM it_financials
)
SELECT * FROM company_ratios ORDER BY company, year;
```

Full query file: [`sql/queries.sql`](./sql/queries.sql)
Dashboard file: [`powerbi/IT_Financial_Dashboard.pbix`](./powerbi/IT_Financial_Dashboard.pbix)
