create database startupiq; 

use startupiq; 

SELECT * FROM startup_funding LIMIT 10; 

--- Query 1 — Year-over-Year Funding Growth

SELECT 
    Year,
    COUNT(*) AS deal_count,
    SUM(Amount_in_USD) AS total_funding,
    ROUND(
        (SUM(Amount_in_USD) - LAG(SUM(Amount_in_USD)) OVER (ORDER BY Year)) 
        * 100.0 / LAG(SUM(Amount_in_USD)) OVER (ORDER BY Year), 
    2) AS yoy_growth_pct
FROM startup_funding
WHERE Amount_in_USD IS NOT NULL
GROUP BY Year
ORDER BY Year; 

--- Query 2 — Average Ticket Size by Funding Stage 

SELECT 
    Investment_Type,
    COUNT(*) AS deal_count,
    SUM(Amount_in_USD) AS total_funding,
    ROUND(AVG(Amount_in_USD), 0) AS avg_ticket_size,
    ROUND(SUM(Amount_in_USD) * 100.0 / 
        (SELECT SUM(Amount_in_USD) FROM startup_funding WHERE Amount_in_USD IS NOT NULL), 2) AS pct_of_total_funding
FROM startup_funding
WHERE Amount_in_USD IS NOT NULL
GROUP BY Investment_Type
ORDER BY total_funding DESC; 

--- Query 3 — City-wise Funding Concentration 

SELECT 
    City_Location,
    COUNT(*) AS deal_count,
    SUM(Amount_in_USD) AS total_funding,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM startup_funding), 2) AS pct_of_total_deals
FROM startup_funding
GROUP BY City_Location
ORDER BY deal_count DESC
LIMIT 10; 

--- Query 4 — True Top Investors (split comma-separated names) 

SET SESSION cte_max_recursion_depth = 5000;

WITH RECURSIVE split_investors AS (
    SELECT 
        Startup_Name,
        TRIM(SUBSTRING_INDEX(Investors_Name, ',', 1)) AS investor,
        CASE 
            WHEN INSTR(Investors_Name, ',') > 0 
            THEN SUBSTRING(Investors_Name, INSTR(Investors_Name, ',') + 1)
            ELSE NULL
        END AS rest
    FROM startup_funding
    WHERE Investors_Name IS NOT NULL AND Investors_Name <> ''

    UNION ALL

    SELECT 
        Startup_Name,
        TRIM(SUBSTRING_INDEX(rest, ',', 1)),
        CASE 
            WHEN INSTR(rest, ',') > 0 
            THEN SUBSTRING(rest, INSTR(rest, ',') + 1)
            ELSE NULL
        END
    FROM split_investors
    WHERE rest IS NOT NULL
)
SELECT 
    CASE 
        WHEN investor IN ('Undisclosed', 'Undisclosed Investor', 'Undisclosed Investors', '') 
        THEN 'Undisclosed'
        ELSE investor 
    END AS investor_name,
    COUNT(DISTINCT Startup_Name) AS deal_count
FROM split_investors
WHERE investor <> ''
GROUP BY investor_name
ORDER BY deal_count DESC
LIMIT 15;

--- Query 5 — Sector Concentration After Fixing E-Commerce Fragmentation

SELECT 
    CASE 
        WHEN Industry_Vertical IN ('Ecommerce', 'E-commerce', 'E-Commerce & M-Commerce platform', 
                                     'Online Marketplace', 'Consumer Internet') 
        THEN 'E-Commerce / Consumer Internet'
        ELSE Industry_Vertical
    END AS sector_grouped,
    COUNT(*) AS deal_count,
    SUM(Amount_in_USD) AS total_funding
FROM startup_funding
WHERE Amount_in_USD IS NOT NULL
GROUP BY sector_grouped
ORDER BY total_funding DESC
LIMIT 10;