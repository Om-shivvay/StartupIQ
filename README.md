# StartupIQ
 "End-to-end analysis of Indian startup funding data using Excel, SQL, and Power BI"
# StartupIQ — Indian Startup Funding Intelligence

An end-to-end analysis of 3,043 startup funding deals in India (2015–2020), built using Excel, SQL, and Power BI. This project identifies capital allocation patterns, sector and geographic concentration, and data quality issues in startup funding data — and documents how each issue was resolved.

## Overview

| | |
|---|---|
| **Dataset** | [Indian Startup Funding](https://www.kaggle.com/datasets/sudalairajkumar/indian-startup-funding) (Kaggle) |
| **Records analyzed** | 3,043 funding deals, 2015–2020 |
| **Tools** | Excel (Power Query, PivotTables), MySQL, Power BI |
| **Deliverables** | Cleaned dataset, SQL analysis scripts, 3-page interactive dashboard, executive report |

## Key Findings

1. **Capital follows a power-law distribution** — Private Equity deals are 35% of all deals by count but capture 78% of total funding. Average PE ticket size (₹23.0M) is ~19x the average Seed ticket (₹1.2M).
2. **Deal volume is declining; funding amount is not** — Deal count fell every year from 2015–2019, but 2017 recorded the highest total funding of the period, indicating a shift toward fewer, larger deals.
3. **Geographic concentration** — Bengaluru, Mumbai, New Delhi, Gurugram, and Noida account for ~76% of all deals.
4. **Inconsistent sector labeling masked E-Commerce's true scale** — Raw data spread e-commerce activity across 7+ inconsistent labels. After consolidation, E-Commerce became the #1 funded sector (previously appeared as Transportation in naive analysis).
5. **Investor data required SQL correction** — ~49% of "top investor" entries were unlabeled/undisclosed variants; a recursive SQL CTE was used to properly split comma-separated multi-investor records for accurate rankings.

## Repository Structure

```
StartupIQ/
├── README.md
├── data/
│   └── clean_startup_data.csv       # Cleaned dataset (post Excel/Power Query processing)
├── sql/
│   └── analysis_queries.sql         # YoY growth, ticket sizes, city concentration, investor split, sector grouping
├── powerbi/
│   └── StartupIQ.pbix               # 3-page interactive dashboard
├── excel/
│   └── clean_startup_data.xlsx      # Pivot tables and charts (exploratory analysis)
└── report/
    └── StartupIQ_Executive_Report.docx
```

## Process

**1. Data Cleaning (Excel / Power Query)**
Standardized date formats, removed currency formatting from funding amounts, consolidated city name variants (Bangalore → Bengaluru, Gurgaon → Gurugram), merged duplicate funding-stage labels, and fixed text encoding artifacts.

**2. Exploratory Analysis (Excel PivotTables)**
Built core analyses: yearly funding trend, top sectors, top cities, funding stage distribution, and investor activity — surfacing the sector-labeling and investor-data issues addressed in later steps.

**3. SQL Analysis (MySQL)**
- Year-over-year growth using window functions (`LAG`)
- Average ticket size and % of total funding by stage
- City-wise concentration
- **Recursive CTE** to split comma-separated investor fields into individual rows for accurate investor rankings
- `CASE`-based sector consolidation to fix E-Commerce label fragmentation

**4. Power BI Dashboard**
Three pages:
- **Overview** — KPI cards, yearly trend (funding vs. deal count), top sectors, top cities
- **Sector Deep-Dive** — Treemap of sector funding share, funding-stage breakdown, expandable sub-vertical matrix
- **Investor & Geography** — City-wise funding map, SQL-corrected investor table, funding-stage funnel

**5. Executive Report**
Full write-up of findings, methodology, limitations, and recommendations for investors, policymakers, and data teams.

## Limitations

- 2020 data is partial (January only) — excluded from year-over-year trend commentary
- `Industry_Vertical` contains 821 unique free-text values; only the largest categories were manually consolidated
- ~960 records have no disclosed funding amount (excluded from amount-based calculations, retained for deal counts)
- "Unknown" values for industry/city reflect genuine missing data in the source file, retained rather than dropped to preserve totals

## Author

Sri Sai Samarth Sistla — BBA graduate
