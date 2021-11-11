Select * 
FROM deaths
ORDER BY 3,4
LIMIT 50;
 

Select * 
FROM vaccinations
ORDER BY 3,4
LIMIT 50; 

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM deaths
ORDER BY 1,2
LIMIT 50; 

-- Looking at Total Cases vs Total Deaths 
SELECT location , date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPerc
FROM deaths
WHERE location = 'Germany'
ORDER BY 1,2; 

-- Looking at Total Cases vs Population 
-- Shows what precentage of population got Covid
SELECT location , date, Population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
FROM deaths
WHERE location = 'Germany'
ORDER BY 1,2; 

-- Looking at Countries wiht Highest Infection Rate compared to Population 
SELECT location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM deaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC; 

-- Showing Countries with Highest Death Count per Population 
SELECT location , MAX(cast(total_deaths as int)) as TotalDeathCount
FROM deaths
where continent is not null
Group by Location, population 
order by TotalDeathCount DESC; 

-- Showing Countries with Highest Death Count per Population 
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM deaths
where continent is null
Group by location
order by TotalDeathCount DESC; 

-- Global Numbers 
SELECT date, SUM(new_cases), SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPerc
FROM deaths
where continent is not null
-- Group by date
ORDER BY 1,2; 

-- Looking at Total Population vs Vaccinations

Select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
SUM(v.new_vaccinations) OVER (Partition by d.Location Order by d.location, d.date) as RollingPeopleVaccinated
FROM deaths d
JOIN vaccinations v
	ON d.location = v.location 
	and d.date = v.date
where d.continent is not null
Order by 2,3;

-- USE CTE

With PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as 
(
Select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
SUM(v.new_vaccinations) OVER (Partition by d.Location Order by d.location, d.date) as RollingPeopleVaccinated
FROM deaths d
JOIN vaccinations v
	ON d.location = v.location 
	and d.date = v.date
where d.continent is not null
)
Select *, (RollingPeopleVaccinated/population)*100 
From PopvsVac; 




-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(v.new_vaccinations) OVER (Partition by d.Location Order by d.location, d.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From deaths d
Join vaccinations v
	On d.location = v.location
	and d.date = v.date
where d.continent is not null 








