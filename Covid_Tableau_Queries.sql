-- 1. Deathpercentage regarding total cases 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From deaths
where continent is not null 
order by 1,2;


-- 2. How many people died in total of Covid per continent.

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From deaths 
where continent is null 
and location not in('Upper middle income','High income','Lower middle income','Lower income','World', 'European Union','International')
Group by location 
order by TotalDeathCount DESC 

-- 3. Infectionrate per country 
Select Location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From deaths
Group by Location, Population 
order by PercentPopulationInfected desc 

-- 4. Country with highest infectionrate among total population per day
Select Location, Population, date, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From deaths
Group by Location,Population,date 
order by PercentPopulationInfected desc 
