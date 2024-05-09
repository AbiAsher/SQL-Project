
Select*
From PortfolioProject..CovidDeaths
Order by 3,4



Select*
From PortfolioProject..CovidVaccinations
Order by 3,4

--Select data that we are going to be using


Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2

--Looking at total cases vs total deaths

Select location, date, total_cases, (total_deaths),(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%Chile%'
Order by 1,2

--Looking at total case vs population
--Shows what percentage of population got covid


Select location, date,population total_cases, (total_cases/population)*100 as InfectionPercentage
From PortfolioProject..CovidDeaths
Where location like '%Chile%'
Order by 1,2

--Looking at countries with highest infection rate compared to poulation


Select location, population total_cases,Max(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as InfectionPercentage
From PortfolioProject..CovidDeaths
--Where location like '%Chile%'
Group by location, population
Order by InfectionPercentage desc

--Showing countries with highest death count per population


Select location, Max(Cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%Chile%'
Where continent is not null
Group by location
Order by TotalDeathCount desc

--Lets break things down by continent

--Showing continents with the highest death count per poulation

Select continent, Max(Cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%Chile%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc

--Global Numbers

Select date, Sum(new_cases) as total_cases, Sum (Cast(new_deaths as int)) as total_deaths, 
Sum (Cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%Chile%'
Where continent is not null
Group by date
Order by 1,2


Select Sum(new_cases) as total_cases, Sum (Cast(new_deaths as int)) as total_deaths, 
Sum (Cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%Chile%'
Where continent is not null
--Group by date
Order by 1,2



Select*
From PortfolioProject .. CovidDeaths Dea
join PortfolioProject..CovidVaccinations Vac
on Dea.location = Vac.location
and Dea.date = Vac.date


--Looking at total population vs vaccination

Select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations
From PortfolioProject .. CovidDeaths Dea
join PortfolioProject..CovidVaccinations Vac
on Dea.location = Vac.location
and Dea.date = Vac.date
Where Dea.continent is not null
Order by 1,2,3

--Use CTE


With PopvsVac ( Continent, location, date, population, New_Vaccinations, RollingPeopleVaccinated)
As 
(
Select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
Sum(Convert(int, Vac.New_Vaccinations)) Over (Partition by  Dea.location Order by Dea.location,
Dea.date) as RollingPeopleVaccinated
From PortfolioProject .. CovidDeaths Dea
join PortfolioProject..CovidVaccinations Vac
on Dea.location = Vac.location
and Dea.date = Vac.date
Where Dea.continent is not null
--Order by 1,2,3
)
Select* , (RollingPeopleVaccinated/population)*100
From PopvsVac

--TEMP TABLE

Create Table #percentpopulationvaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #percentpopulationvaccinated
Select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
Sum(Convert(int, Vac.New_Vaccinations)) Over (Partition by  Dea.location Order by Dea.location,
Dea.date) as RollingPeopleVaccinated
From PortfolioProject .. CovidDeaths Dea
join PortfolioProject..CovidVaccinations Vac
on Dea.location = Vac.location
and Dea.date = Vac.date
Where Dea.continent is not null
 
 Select* , (RollingPeopleVaccinated/population)*100
From #percentpopulationvaccinated


DROP TABLE IF EXISTS #percentpopulationvaccinated
Create Table #percentpopulationvaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #percentpopulationvaccinated
Select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
Sum(Convert(int, Vac.New_Vaccinations)) Over (Partition by  Dea.location Order by Dea.location,
Dea.date) as RollingPeopleVaccinated
From PortfolioProject .. CovidDeaths Dea
join PortfolioProject..CovidVaccinations Vac
on Dea.location = Vac.location
and Dea.date = Vac.date
--Where Dea.continent is not null
 
 Select* , (RollingPeopleVaccinated/population)*100
From #percentpopulationvaccinated


--Creating view to store data for future visualisaion

Create View percentpopulationvaccinated as
Select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
Sum(Convert(int, Vac.New_Vaccinations)) Over (Partition by  Dea.location Order by Dea.location,
Dea.date) as RollingPeopleVaccinated
From PortfolioProject .. CovidDeaths Dea
join PortfolioProject..CovidVaccinations Vac
on Dea.location = Vac.location
and Dea.date = Vac.date
--Where Dea.continent is not null

Select*
From percentpopulationvaccinated






