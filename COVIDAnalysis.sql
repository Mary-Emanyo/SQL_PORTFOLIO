SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeath
ORDER BY 1,2

--Total cases VS total death
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeath
WHERE location like 'Nigeria'
ORDER BY 1,2

--Total cases VS Population
--shows percentage of population that got covid
SELECT location, date, population, total_cases, (total_cases/population)*100 AS PopulationInfected
FROM PortfolioProject..CovidDeath
WHERE location like '%states%'
ORDER BY 1,2

--Companies with higher infection rate and population
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 AS PopulationInfected
FROM PortfolioProject..CovidDeath
Group By location, population
ORDER BY PopulationInfected desc

--Showing the countries with highest death count per population
SELECT location, MAX(CAST(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeath
Where continent is not null
Group By location
ORDER BY TotalDeathCount desc

--Streamlining to continent
SELECT location, MAX(CAST(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeath
Where continent is null
Group By location
ORDER BY TotalDeathCount desc


--Showing continent with highest death count
SELECT continent, MAX(CAST(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeath
Where continent is not null
Group By continent
ORDER BY TotalDeathCount desc

--Global Numbers

SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/ SUM(new_cases) * 100 as DeathPercentage
FROM PortfolioProject..CovidDeath
--WHERE location like '%states%'
Where continent is not null
ORDER BY 1,2

--Total population VS vaccination
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by  dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not null
Order BY 2,3

--Total population of people vaccinated per country(using CTE)
With PopVsVacc (Continent, Location, Date, Population,New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by  dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not null
--Order BY 2,3
)
SELECT *,(RollingPeopleVaccinated/Population)*100 as Pecent_Pop_of_People_Vaccinated
FROM PopVsVacc


--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by  dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not null
--Order BY 2,3

SELECT *,(RollingPeopleVaccinated/Population)*100 as Pecent_Pop_of_People_Vaccinated
FROM #PercentPopulationVaccinated

--Create a view to store data for later visualization
Create view PercentPopulationVaccinated as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by  dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not null





