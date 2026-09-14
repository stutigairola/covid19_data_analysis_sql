USE covid_database;
--  Standardize Date Formats
-- Convert string date values into standard MySQL YYYY-MM-DD date format
UPDATE covid_deaths 
SET date = STR_TO_DATE(date, '%m/%d/%Y')
WHERE date LIKE '%/%';
UPDATE covid_vaccinations 
SET date = STR_TO_DATE(date, '%m/%d/%Y')
WHERE date LIKE '%/%';
-- Handle Missing or Blank Values
-- Replace NULLs and empty strings with 0 across primary numerical fields
UPDATE covid_deaths
SET total_cases = COALESCE(NULLIF(total_cases, ''), 0),
    total_deaths = COALESCE(NULLIF(total_deaths, ''), 0),
    new_cases = COALESCE(NULLIF(new_cases, ''), 0),
    new_deaths = COALESCE(NULLIF(new_deaths, ''), 0);
UPDATE covid_vaccinations
SET new_vaccinations = COALESCE(NULLIF(new_vaccinations, ''), 0);
-- Modify Data Types Explicitly
-- Ensure columns hold exact numeric types for aggregation compatibility
ALTER TABLE covid_deaths
MODIFY COLUMN total_cases INT,
MODIFY COLUMN total_deaths INT,
MODIFY COLUMN population BIGINT;
ALTER TABLE covid_vaccinations
MODIFY COLUMN new_vaccinations BIGINT;
-- Remove Blank Whitespaces from Key String Metrics
UPDATE covid_deaths
SET continent = TRIM(continent),
    location = TRIM(location);

UPDATE covid_vaccinations
SET continent = TRIM(continent),
    location = TRIM(location);
--  Filter & Verify Cleaned Data Structure
-- Verify that regional aggregate records (where continent is NULL or empty) are removed
SELECT 
    iso_code, 
    continent, 
    location, 
    date, 
    population, 
    total_cases, 
    total_deaths
FROM covid_deaths
WHERE continent IS NOT NULL 
  AND continent != ''
ORDER BY location, date;
