CREATE TABLE it_financials (
    company VARCHAR(50),
    year VARCHAR(10),
    revenue NUMERIC,
    cogs NUMERIC,
    operating_profit NUMERIC,
    net_profit NUMERIC,
    total_assets NUMERIC,
    current_assets NUMERIC,
    total_liabilities NUMERIC,
    current_liabilities NUMERIC,
    total_debt NUMERIC,
    total_equity NUMERIC
);

TRUNCATE TABLE it_financials;

SELECT * FROM it_financials ORDER BY company, year;

SELECT COUNT(*) FROM it_financials;

--Query 1: Basic Ranking — Har Saal Highest Revenue Wali Company--
SELECT
    year,
    company,
    revenue,
    RANK() OVER (PARTITION BY year ORDER BY revenue DESC) AS revenue_rank
FROM it_financials
ORDER BY year, revenue_rank;

--Query 2: Ratios Calculate Karna--
SELECT
    company,
    year,
    ROUND((revenue - cogs) / revenue * 100, 2) AS gross_margin_pct,
    ROUND(net_profit / revenue * 100, 2) AS net_margin_pct,
    ROUND(net_profit / total_equity * 100, 2) AS roe_pct,
    ROUND(net_profit / total_assets * 100, 2) AS roa_pct,
    ROUND(current_assets / current_liabilities, 2) AS current_ratio,
    ROUND(total_debt / total_equity, 2) AS debt_to_equity
FROM it_financials
ORDER BY company, year;


TRUNCATE TABLE it_financials;


--checking duplicate--
SELECT company, year, COUNT(*)
FROM it_financials
GROUP BY company, year
HAVING COUNT(*) > 1;


--counting table data--
SELECT COUNT(*) FROM it_financials;

--this command will show each company how many row contain --
SELECT company, COUNT(*) AS year_count
FROM it_financials
GROUP BY company;

--checking hcl rows by date--
SELECT year FROM it_financials WHERE company = 'HCL Technologies' ORDER BY year;

--filling hcl missing data--
INSERT INTO it_financials (
    company, year, revenue, cogs, operating_profit, net_profit,
    total_assets, current_assets, total_liabilities, current_liabilities,
    total_debt, total_equity
) VALUES (
    'HCL Technologies', 'FY25', 117055, 91551, 25504, 17390,
    104480, 60685, 34825, 28549, 6276, 69655
);

--verifying data--
SELECT company, COUNT(*) AS year_count
FROM it_financials
GROUP BY company;

--counting rows--
SELECT COUNT(*) FROM it_financials;

--Query 3: CTE (Common Table Expression) — Ratios Ko Reusable Banana--
WITH company_ratios AS (
    SELECT
        company,
        year,
        revenue,
        net_profit,
        ROUND((revenue - cogs) / revenue * 100, 2) AS gross_margin_pct,
        ROUND(net_profit / revenue * 100, 2) AS net_margin_pct,
        ROUND(net_profit / total_equity * 100, 2) AS roe_pct,
        ROUND(net_profit / total_assets * 100, 2) AS roa_pct,
        ROUND(current_assets / current_liabilities, 2) AS current_ratio,
        ROUND(total_debt / total_equity, 2) AS debt_to_equity
    FROM it_financials
)
SELECT *
FROM company_ratios
WHERE roe_pct > 20
ORDER BY roe_pct DESC;

--Query 4: Window Function — Rolling 3-Year Average Margin + Company Rank
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