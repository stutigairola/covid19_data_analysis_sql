-- Database and Schema Setup
CREATE DATABASE IF NOT EXISTS covid_database;
USE covid_database;
CREATE TABLE IF NOT EXISTS covid_deaths (
    iso_code VARCHAR(10),
    continent VARCHAR(50),
    location VARCHAR(100),
    date TEXT,
    population BIGINT,
    total_cases BIGINT,
    new_cases BIGINT,
    total_deaths BIGINT,
    new_deaths BIGINT
);
CREATE TABLE IF NOT EXISTS covid_vaccinations (
    iso_code VARCHAR(10),
    continent VARCHAR(50),
    location VARCHAR(100),
    date TEXT,
    new_vaccinations BIGINT
);
--  Select Initial Data for Analysis
SELECT 
    location, 
    date, 
    total_cases, 
    new_cases, 
    total_deaths, 
    population
FROM covid_deaths
WHERE continent IS NOT NULL AND continent != ''
ORDER BY location, date;
--  Total Cases vs Total Deaths (Likelihood of Dying if Infected)
SELECT 
    location, 
    date, 
    total_cases, 
    total_deaths, 
    (total_deaths / NULLIF(total_cases, 0)) * 100 AS death_percentage
FROM covid_deaths
WHERE continent IS NOT NULL AND continent != ''
ORDER BY location, date;
-- Total Cases vs Population (Percentage of Population Infected)
SELECT 
    location, 
    date, 
    population, 
    total_cases, 
    (total_cases / NULLIF(population, 0)) * 100 AS percent_population_infected
FROM covid_deaths
WHERE continent IS NOT NULL AND continent != ''
ORDER BY location, date;
-- Countries with Highest Infection Rate Relative to Population
SELECT 
    location, 
    population, 
    MAX(total_cases) AS highest_infection_count, 
    MAX((total_cases / NULLIF(population, 0))) * 100 AS percent_population_infected
FROM covid_deaths
WHERE continent IS NOT NULL AND continent != ''
GROUP BY location, population
ORDER BY percent_population_infected DESC;
--  Countries with Highest Death Count per Population
SELECT 
    location, 
    MAX(CAST(total_deaths AS UNSIGNED)) AS total_death_count
FROM covid_deaths
WHERE continent IS NOT NULL AND continent != ''
GROUP BY location
ORDER BY total_death_count DESC;
-- Breaking Down Metrics by Continent
SELECT 
    continent, 
    MAX(CAST(total_deaths AS UNSIGNED)) AS total_death_count
FROM covid_deaths
WHERE continent IS NOT NULL AND continent != ''
GROUP BY continent
ORDER BY total_death_count DESC;
-- Global Summary Totals
SELECT 
    SUM(new_cases) AS global_total_cases, 
    SUM(CAST(new_deaths AS UNSIGNED)) AS global_total_deaths, 
    (SUM(CAST(new_deaths AS UNSIGNED)) / NULLIF(SUM(new_cases), 0)) * 100 AS global_death_percentage
FROM covid_deaths
WHERE continent IS NOT NULL AND continent != '';
-- Total Population vs New Vaccinations (JOIN)
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations
FROM covid_deaths dea
JOIN covid_vaccinations vac
    ON dea.location = vac.location
   AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.continent != ''
ORDER BY dea.location, dea.date;
-- Cumulative Rolling Vaccinations (Subquery for MySQL Compatibility)
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    (
        SELECT SUM(v.new_vaccinations)
        FROM covid_vaccinations v
        WHERE v.location = dea.location 
          AND v.date <= dea.date
    ) AS rolling_people_vaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vac
    ON dea.location = vac.location
   AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.continent != ''
ORDER BY dea.location, dea.date;
