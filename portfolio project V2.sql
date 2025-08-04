SELECT *
From PortfolioProject..CovidDeaths
order by 3,4 


SELECT *
From PortfolioProject..CovidVacination
order by 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

--Looking at total cases vs Total Deaths

SELECT 
  Location, 
  CAST([date] AS DATE) AS [date],
  CAST(total_cases AS FLOAT) AS total_cases,
  CAST(new_cases AS FLOAT) AS new_cases,
  CAST(total_deaths AS FLOAT) AS total_deaths,
  CAST(population AS FLOAT) AS population
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 2;


SELECT 
  Location, 
  CAST([date] AS DATE) AS [date],
  CAST(total_cases AS FLOAT) AS total_cases,
  CAST(total_deaths AS FLOAT) AS total_deaths
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 2;

SELECT 
  Location, 
  CAST([date] AS DATE) AS [date],
  CAST(total_cases AS FLOAT) AS total_cases,
  CAST(total_deaths AS FLOAT) AS total_deaths,
  ROUND(CAST(total_deaths AS FLOAT) / NULLIF(CAST(total_cases AS FLOAT), 0) * 100, 2) AS death_rate_percentage
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 2;


SELECT 
  Location, 
  CAST([date] AS DATE) AS [date],
  CAST(total_cases AS FLOAT) AS total_cases,
  CAST(total_deaths AS FLOAT) AS total_deaths,
  (CAST(total_deaths AS FLOAT) / NULLIF(CAST(total_cases AS FLOAT), 0) * 100) AS death_rate_percentage
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 2;

SELECT 
  Location, 
  CAST([date] AS DATE) AS [date],
  CAST(total_cases AS FLOAT) AS total_cases,
  CAST(total_deaths AS FLOAT) AS total_deaths,
  ROUND(CAST(total_deaths AS FLOAT) / NULLIF(CAST(total_cases AS FLOAT), 0) * 100, 2) AS death_rate_percentage
FROM PortfolioProject..CovidDeaths
where location like '%uganda%'
ORDER BY 1, 2;


--Looking at Total Cses vs Population
--Shows what percentage of the population got Covid

SELECT 
  Location, 
  CAST([date] AS DATE) AS [date],
  CAST(total_cases AS FLOAT) AS total_cases,
  CAST(population AS FLOAT) AS population,
  (CAST(total_cases AS FLOAT) / NULLIF(CAST(population AS FLOAT), 0) * 100) AS DeathPercentage
FROM PortfolioProject..CovidDeaths
where location like '%uganda%'
ORDER BY 1, 2;

--Looking at countries with highest infection rate compared to population

SELECT 
  Location, 
  MAX(CAST(total_cases AS FLOAT)) AS highestInfectionCount,
  AVG(CAST(population AS FLOAT)) AS population,
  ROUND(MAX(CAST(total_cases AS FLOAT)) / NULLIF(AVG(CAST(population AS FLOAT)), 0) * 100, 2) AS infectionRatePercentage
FROM PortfolioProject..CovidDeaths
WHERE population IS NOT NULL AND total_cases IS NOT NULL
GROUP BY Location
ORDER BY 1,2

SELECT 
  Location, 
  MAX(CAST(total_cases AS FLOAT)) AS highestInfectionCount,
  AVG(CAST(population AS FLOAT)) AS population,
  ROUND(MAX(CAST(total_cases AS FLOAT)) / NULLIF(AVG(CAST(population AS FLOAT)), 0) * 100, 2) AS infectionRatePercentage
FROM PortfolioProject..CovidDeaths
WHERE population IS NOT NULL AND total_cases IS NOT NULL
GROUP BY Location
ORDER BY infectionRatePercentage desc

SELECT 
  Location, 
  MAX(CAST(total_cases AS FLOAT)) AS highestInfectionCount,
  AVG(CAST(population AS FLOAT)) AS population,
  ROUND(MAX(CAST(total_cases AS FLOAT)) / NULLIF(AVG(CAST(population AS FLOAT)), 0) * 100, 2) AS infectionRatePercentage
FROM PortfolioProject..CovidDeaths
GROUP BY Location
ORDER BY infectionRatePercentage desc

--Showing countries with the hughest death count per population
SELECT 
  Location, 
  MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount desc

SELECT 
  Location, 
  MAX(CAST(total_deaths AS FLOAT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE 
  Location NOT IN ('World', 'Africa', 'Asia', 'Europe', 'European Union', 'South America', 'North America')
GROUP BY Location
ORDER BY TotalDeathCount DESC;

--Break down based on continent

SELECT 
  location, 
  MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE Location IN ('World', 'Africa', 'Asia', 'Europe', 'European Union', 'South America', 'North America', 'Oceania', 'International')
GROUP BY location
ORDER BY TotalDeathCount desc

--Continents with highest death count per population

SELECT 
  location, 
  MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE Location IN ('World', 'Africa', 'Asia', 'Europe', 'European Union', 'South America', 'North America', 'Oceania', 'International')
GROUP BY location
ORDER BY TotalDeathCount desc

--GLOBAL NUMBERS

--OPTION ONE--
SELECT  
  CAST([date] AS DATE) AS [date],
  SUM(CAST(new_cases AS FLOAT)) AS total_cases,
  SUM(CAST(new_deaths AS INT)) as total_deaths,
  SUM(CAST(new_deaths AS INT) / NULLIF(CAST(new_cases AS FLOAT), 0) * 100) AS deathPercentage
FROM PortfolioProject..CovidDeaths
Group by [date]
ORDER BY 1,2;

--OPTION TWO--

SELECT  
  CAST([date] AS DATE) AS [date],
  SUM(CAST(new_cases AS FLOAT)) AS total_cases,
  SUM(CAST(new_deaths AS INT)) AS total_deaths,
  (SUM(CAST(new_deaths AS FLOAT)) / NULLIF(SUM(CAST(new_cases AS FLOAT)), 0)) * 100 AS deathPercentage
FROM PortfolioProject..CovidDeaths
WHERE new_cases IS NOT NULL AND new_deaths IS NOT NULL
GROUP BY CAST([date] AS DATE)
ORDER BY [date];

SELECT  
  SUM(CAST(new_cases AS FLOAT)) AS total_cases,
  SUM(CAST(new_deaths AS INT)) AS total_deaths,
  (SUM(CAST(new_deaths AS FLOAT)) / NULLIF(SUM(CAST(new_cases AS FLOAT)), 0)) * 100 AS deathPercentage
FROM PortfolioProject..CovidDeaths
WHERE Continent IS NOT NULL
--GROUP BY CAST([date] AS DATE)
ORDER BY 1,2

--TOTAL POPULATION VS VACCINATIONS

SELECT *
FROM PortfolioProject..CovidVacination dea
JOIN PortfolioProject..CovidDeaths vac
	ON dea.location = vac.location
	 AND CAST(dea.[date] AS DATE) = CAST(vac.[date] AS DATE)
	
SELECT dea.continent, dea.location, CAST(dea.[date] AS DATE), dea.population, CAST(vac.[new_vaccinations] AS FLOAT) as new_vaccinations
FROM PortfolioProject..CovidVacination vac
JOIN PortfolioProject..CovidDeaths dea
	ON dea.location = vac.location
	 AND CAST(dea.[date] AS DATE) = CAST(vac.[date] AS DATE)
where dea.continent is not null
order by 2,3

--OPTION ONE--

SELECT dea.continent, dea.location, CAST(dea.[date] AS DATE), dea.population, CAST(vac.[new_vaccinations] AS FLOAT) as new_vaccinations,
SUM(Cast(vac.[new_vaccinations] AS int)) OVER (Partition by dea.location)
FROM PortfolioProject..CovidVacination vac
JOIN PortfolioProject..CovidDeaths dea
	ON dea.location = vac.location
	 AND CAST(dea.[date] AS DATE) = CAST(vac.[date] AS DATE)
where dea.continent is not null
order by 2,3

--OPTION TWO--

SELECT dea.continent, dea.location, CAST(dea.[date] AS DATE), dea.population, CAST(vac.[new_vaccinations] AS FLOAT) as new_vaccinations,
SUM(CONVERT(int,vac.[new_vaccinations])) OVER (Partition by dea.location)
FROM PortfolioProject..CovidVacination vac
JOIN PortfolioProject..CovidDeaths dea
	ON dea.location = vac.location
	 AND CAST(dea.[date] AS DATE) = CAST(vac.[date] AS DATE)
where dea.continent is not null
order by 2,3


SELECT dea.continent, dea.location, CAST(dea.[date] AS DATE), dea.population, CAST(vac.[new_vaccinations] AS FLOAT) as new_vaccinations,
SUM(CONVERT(int,vac.[new_vaccinations])) OVER (Partition by dea.location order by dea.location, Cast(dea.[date] as DATE))
FROM PortfolioProject..CovidVacination vac
JOIN PortfolioProject..CovidDeaths dea
	ON dea.location = vac.location
	 AND CAST(dea.[date] AS DATE) = CAST(vac.[date] AS DATE)
where dea.continent is not null
order by 2,3

--USING CTE

With PopvsVac (Continent, location, date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, CAST(dea.[date] AS DATE), dea.population, CAST(vac.[new_vaccinations] AS FLOAT) as new_vaccinations,
SUM(CONVERT(int,vac.[new_vaccinations])) OVER (Partition by dea.location order by dea.location, Cast(dea.[date] as DATE)) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidVacination vac
JOIN PortfolioProject..CovidDeaths dea
	ON dea.location = vac.location
	 AND CAST(dea.[date] AS DATE) = CAST(vac.[date] AS DATE)
where dea.continent is not null
)
Select *
From PopvsVac


WITH PopvsVac (Continent, location, date, Population, New_vaccinations, RollingPeopleVaccinated)
AS
(
  SELECT 
    dea.continent, 
    dea.location, 
    CAST(dea.[date] AS DATE) AS date, 
    dea.population, 
    TRY_CAST(vac.[new_vaccinations] AS FLOAT) AS new_vaccinations,
    SUM(TRY_CAST(vac.[new_vaccinations] AS BIGINT)) 
      OVER (PARTITION BY dea.location ORDER BY dea.location, CAST(dea.[date] AS DATE)) AS RollingPeopleVaccinated
  FROM PortfolioProject..CovidVacination vac
  JOIN PortfolioProject..CovidDeaths dea
    ON dea.location = vac.location
    AND CAST(dea.[date] AS DATE) = CAST(vac.[date] AS DATE)
  WHERE dea.continent IS NOT NULL
    AND ISNUMERIC(vac.[new_vaccinations]) = 1
)

SELECT *, (RollingPeopleVaccinated * 1.0 / Population) * 100 AS VaccinationPercentage
FROM PopvsVac;

--TEMP TABLE


DROP TABLE IF exists #PercentagePopulationVaccinated
CREATE TABLE #PercentagePopulationVaccinated
(
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

INSERT INTO #PercentagePopulationVaccinated
SELECT 
    dea.continent, 
    dea.location, 
    CAST(dea.[date] AS DATE) AS date, 
    dea.population, 
    TRY_CAST(vac.[new_vaccinations] AS FLOAT) AS new_vaccinations,
    SUM(TRY_CAST(vac.[new_vaccinations] AS BIGINT)) 
      OVER (PARTITION BY dea.location ORDER BY dea.location, CAST(dea.[date] AS DATE)) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidVacination vac
JOIN PortfolioProject..CovidDeaths dea
    ON dea.location = vac.location
    AND CAST(dea.[date] AS DATE) = CAST(vac.[date] AS DATE)
--WHERE dea.continent IS NOT NULL
  AND ISNUMERIC(vac.[new_vaccinations]) = 1;

SELECT *, 
       (RollingPeopleVaccinated * 1.0 / Population) * 100 AS VaccinationPercentage
FROM #PercentagePopulationVaccinated;

--CREATING VIEW TO STORE DATA FOR VISUALIZATION

Create View PercentagepopulationVaccinated as
SELECT 
    dea.continent, 
    dea.location, 
    CAST(dea.[date] AS DATE) AS date, 
    dea.population, 
    TRY_CAST(vac.[new_vaccinations] AS FLOAT) AS new_vaccinations,
    SUM(TRY_CAST(vac.[new_vaccinations] AS BIGINT)) 
      OVER (PARTITION BY dea.location ORDER BY dea.location, CAST(dea.[date] AS DATE)) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidVacination vac
JOIN PortfolioProject..CovidDeaths dea
    ON dea.location = vac.location
    AND CAST(dea.[date] AS DATE) = CAST(vac.[date] AS DATE)
WHERE dea.continent IS NOT NULL
  AND ISNUMERIC(vac.[new_vaccinations]) = 1;


  SELECT DB_NAME() AS CurrentDatabase;

CREATE VIEW new_vaccinations AS
SELECT 
    dea.continent, 
    dea.location, 
    CAST(dea.[date] AS DATE) AS date,  -- ✅ Gave it a name
    dea.population, 
    CAST(vac.[new_vaccinations] AS FLOAT) AS new_vaccinations,
    SUM(CONVERT(INT, vac.[new_vaccinations])) 
        OVER (PARTITION BY dea.location ORDER BY dea.location, CAST(dea.[date] AS DATE)) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidVacination vac
JOIN PortfolioProject..CovidDeaths dea
    ON dea.location = vac.location
    AND CAST(dea.[date] AS DATE) = CAST(vac.[date] AS DATE)
WHERE dea.continent IS NOT NULL;



