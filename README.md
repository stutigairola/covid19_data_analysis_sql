# COVID-19 Data Analysis & Exploration (MySQL)

## Overview
This repository contains an end-to-end SQL project analyzing global COVID-19 data. The project covers schema definition, data cleaning, string transformation, null handling, exploratory data analysis (EDA), and complex aggregations including rolling vaccination metrics using MySQL.

---

## Technical Details & Query Breakdown

### 1. Data Cleaning (`covid_data_cleaning.sql`)
* **Date Standardization:** Converts string date entries into standardized MySQL `DATE` format using `STR_TO_DATE()`.
* **Null & Blank Handling:** Implements `COALESCE()` and `NULLIF()` to handle missing values and prevent division-by-zero runtime errors.
* **Type Casting:** Explicitly casts string metrics to `INT` and `BIGINT` data types for numerical operations.
* **String Sanitization:** Applies `TRIM()` to strip whitespace from location and continent fields.

### 2. Exploratory Data Analysis (`covid_data_exploration.sql`)
* **Mortality Metrics:** Calculates infection-to-death ratios (`total_deaths / total_cases`) across regions.
* **Population Impact:** Measures percentage of population infected per country.
* **Grouped Aggregations:** Analyzes aggregate mortality totals ordered by continent and individual nations.
* **Vaccination Rollouts:** Joins mortality and vaccination datasets to derive cumulative rolling vaccination totals over time using correlated subqueries.

---

## Repository Structure

```text
covid19_data_analysis_sql/
├── covid_data_cleaning.sql     # Schema creation, date parsing, and null handling
├── covid_data_exploration.sql  # EDA queries, mortality rates, and rolling JOINs
└── README.md                   # Project documentation
